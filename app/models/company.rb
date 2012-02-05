class Company < ActiveRecord::Base
  
  COMPANY_TYPES = ['SA', 'SAS', 'SARL', 'SC', 'EI', 'EURL', 'Other']
  
  attr_accessible :role, :name, :legal_name, :skill_tag_list, :sectoral_tag_list, :company_category_ids, :siret, :rcs, :tva_id, :company_type, :capital, :code, :creation_date
  attr_accessible :description, :logo, :logo_cache, :linkedin, :twitter, :facebook, :website, :balance_sheets_attributes, :addresses_attributes, :pictures_attributes
  
  scope :cabinets, where({ :role => :cabinet })
  
  validates :name, :presence => true
  validates :capital, :numericality => true, :allow_blank => true
  validates :creation_date, :presence => true
  validates :role, :presence => true, :inclusion => { :in => ['cabinet', 'client'] }
  validates :siret, :presence => true, :uniqueness => true
  validates :company_type, :inclusion => { :in => COMPANY_TYPES }, :presence => true
  
  validates :balance_sheet_year, :numericality => true, :allow_blank => true
  validates :balance_sheet_sales, :numericality => true, :allow_blank => true
  validates :balance_sheet_number_of_people, :numericality => true, :allow_blank => true
  
  acts_as_taggable_on :skill_tags, :sectoral_tags
  
  has_and_belongs_to_many :company_categories, join_table: 'companies_categories'
  has_and_belongs_to_many :tracked_proposals, join_table: 'companies_tracked_proposals', class_name: 'Proposal', uniq: true
  
  has_many :user_companies, :dependent => :destroy
  has_many :users, :through => :user_companies
  has_many :proposals, :through => :user_companies
  has_many :testimonials
  has_many :lists, :dependent => :destroy
  has_many :addresses, :as => :addressable, :dependent => :destroy
  has_many :balance_sheets, :dependent => :destroy
  has_many :pictures, :as => :pictureable, :dependent => :destroy
  has_many :proposal_trackings
  
  accepts_nested_attributes_for :addresses, :reject_if => proc {|attrs| attrs['address_type'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :balance_sheets, :reject_if => proc {|attrs| attrs['year'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :pictures, :reject_if => proc {|attrs| attrs['file'].blank? }, :allow_destroy => true
  
  store :cached_data
  before_save :update_cached_datas
  
  after_create :append_black_list
  before_save :refresh_current_balance_sheet
  before_save :update_description
  
  mount_uploader :logo, LogoUploader
  
  define_index do
    indexes name
    indexes legal_name
    indexes description
    indexes user_companies.user.firstname, as: :user_firstnames
    indexes user_companies.user.lastname, as: :user_lastnames
    indexes addresses.locality.title, as: :locality_title
    indexes addresses.locality.code, as: :locality_code
    indexes siret
    indexes taggings.tag.name, as: :tag_names
    indexes company_categories.title, :as => :category_title
    
    has addresses.locality.id, :as => :locality, :facet => true
    has taggings.tag_id, :facet => true, as: 'sectors'
    has taggings.tag_id, :facet => true, as: 'skills'
    has taggings.id, facet: true, as: 'taggings'
    has company_categories.id, :as => :category, :facet => true
    has balance_sheet_number_of_people, :as => :number_of_people, :facet => true
    has "CRC32(companies.role)", :type => :integer, :as => :role
    
    has created_at, :sort => true
    
    set_property field_weights: {
      name:             10,
      legal_name:       10,
      tag_names:        5,
      locality_title:   5,
      locality_code:    5,
      category_title:   2,
      user_firstnames:  2,
      user_lastnames:   2
    }
  end
  
  sphinx_scope(:ts_cabinets){
    { :conditions => { :role => 'cabinet'.to_crc32 } }
  }
  
  def headquarter
    @headquarter || addresses.headquarter.first
  end
  
  def update_rates
    [:global, :price, :reactivity, :relational, :approach, :expertise].each do |scope|
      rate = Testimonial.select("AVG(#{scope}_rate) as avg_#{scope}_rate").where("company_id=#{read_attribute(:id)} and #{scope}_rate IS NOT NULL and #{scope}_rate > 0").first
      write_attribute("#{scope}_rate", rate.send("avg_#{scope}_rate")) if rate.respond_to?("avg_#{scope}_rate")
    end
    
    # we have to rework things. we require all rates to be filled or store a counter for each scope. but this is not ok now
    write_attribute :ratings_count, Testimonial.where("company_id=#{read_attribute(:id)} and global_rate IS NOT NULL and global_rate > 0").count
  end
  
  def refresh_current_balance_sheet
    last = balance_sheets.order('year desc').first
    
    if last
      write_attribute :balance_sheet_year, last.year
      write_attribute :balance_sheet_sales, last.sales
      write_attribute :balance_sheet_number_of_people, last.number_of_people
    end
  end
  
  def append_black_list
    List.create :title => "Blacklist", :list_type => 'blacklist', :company_id => id
  end
  
  def update_description
    write_attribute :description_html, (RedCloth.new(description).to_html rescue nil)
  end
  
  def website=(str)
    write_attribute :website, str.gsub('http://', '')
  end
  
  def update_cached_datas
    cached_data[:skills] = skill_tags.map{|t| t.name }
    cached_data[:sectors] = sectoral_tags.map{|t| t.name }
    cached_data[:categories] = company_categories.map{|c| c.title }
    cached_data[:localities] = addresses.map{|a| "#{a.locality.title} (#{a.locality.code})" }
  end
    
end
