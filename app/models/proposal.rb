class Proposal < ActiveRecord::Base

  belongs_to :user_company
  has_many :proposal_trackings
  has_many :proposal_documents, :dependent => :destroy
  has_many :addresses, :as => :addressable, :dependent => :destroy
  
  has_and_belongs_to_many :company_categories, join_table: 'proposal_company_categories'
  has_and_belongs_to_many :company_addresses, join_table: 'proposal_company_addresses', class_name: 'Address'
  has_and_belongs_to_many :following_companies, join_table: 'companies_tracked_proposals', class_name: 'Company', uniq: true
  
  accepts_nested_attributes_for :proposal_documents, :reject_if => proc {|attrs| attrs['document'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :reject_if => proc {|attrs| attrs['locality_str'].blank? }, :allow_destroy => true
  
  validates :summary, :presence => true
  validates :user_company, :presence => true
  
  acts_as_taggable_on :skill_tags, :sectoral_tags
  
  store :cached_data
  before_save :update_cached_datas
  
  before_save :save_addresses_as_company_addresses
  before_save :update_description
  
  define_index do
    indexes summary
    indexes description
    indexes user_company.user.firstname, as: :user_firstname
    indexes user_company.user.lastname, as: :user_lastname
    indexes user_company.company.name, as: :company_name
    indexes company_addresses.locality.title, as: :locality_title
    indexes company_addresses.locality.code, as: :locality_code
    indexes taggings.tag.name, as: :tag_names
    indexes company_categories.title, :as => :category_title
    
    has created_at, :sort => true
    has start_at, :sort => true
    has end_at, :sort => true
    
    has "CASE WHEN start_at <= NOW() AND end_at > NOW() THEN 1 ELSE 0 END", :type => :integer, :as => :current
    has "CASE WHEN start_at <= NOW() AND end_at < NOW() THEN 1 ELSE 0 END", :type => :integer, :as => :archived
    has "CASE WHEN proposals.created_at >= DATE_ADD(NOW(), INTERVAL -15 DAY) THEN 1 ELSE 0 END", :type => :integer, :as => :two_weeks_old
    has public
    
    has addresses.locality.id, :as => :address_locality, :facet => true
    has company_addresses.locality.id, :as => :locality, :facet => true
    has taggings.tag_id, :as => :tags, :facet => true
    has taggings.tag_id, :as => :skills, :facet => true
    has taggings.tag_id, :as => :sectors, :facet => true
    has taggings.id, :as => :taggings, :facet => true
    has company_categories.id, :as => :category, :facet => true
    has user_company.company_id, as: :company
    
    set_property field_weights: {
      summary:          10,
      company_name:     8,
      tag_names:        5,
      locality_title:   5,
      locality_code:    5,
      category_title:   2,
      user_firstname:   2,
      user_lastname:    2
    }
  end
  
  sphinx_scope(:ts_current) {
    { :with => { :current => 1 } }
  }
  
  sphinx_scope(:ts_archived) {
    { :with => { :archived => 1 } }
  }
  
  sphinx_scope(:ts_public) {
    { :with => { :public => 1 } }
  }
  
  scope :public, where(public: true)
  
  # dirty trick to make sphinx usage easier
  def save_addresses_as_company_addresses
    
    # add missing addresses
    addresses.each do |address|
      if !company_addresses.include?(address)
        puts "add address #{address.id}"
        company_addresses << address
      end
    end
    
    # remove removed addresses
    company_addresses.each do |address|
      if address.addressable_type == 'Proposal' && !addresses.include?(address)
        company_addresses.delete address
      end
    end
    
  end

  def update_description
    write_attribute :description_html, (RedCloth.new(description).to_html rescue nil)
  end
  
  def current?
    start_at && start_at < Time.now && end_at && end_at > Time.now
  end
  
  def finished?
    !current?
  end
  
  def update_cached_datas
    cached_data[:skills] = skill_tags.map{|t| t.name }
    cached_data[:sectors] = sectoral_tags.map{|t| t.name }
    cached_data[:localities] = company_addresses.map{|a| "#{a.locality.title} (#{a.locality.code})" }
  end

end