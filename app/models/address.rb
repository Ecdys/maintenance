# encoding: utf-8

class Address < ActiveRecord::Base
  
  attr_accessor :country_str, :locality_str, :postal_code_str
  
  belongs_to :addressable, :polymorphic => true
  belongs_to :locality, :class_name => 'GeographicArea'
  belongs_to :country, :class_name => 'GeographicArea'
  belongs_to :administrative_area, :class_name => 'GeographicArea'
  belongs_to :subadministrative_area, :class_name => 'GeographicArea'
  
  validates :addressable, :presence => true
  validates :lat, :numericality => true, :allow_blank => true
  validates :lng, :numericality => true, :allow_blank => true
  
  validates_presence_of :address_type, :street, :locality, :country, :lat, :lng, :if => :company?
  validates :email, :format => { :with => Devise::email_regexp }, :allow_blank => true
  
  #validates :address_type, :presence => true
  
  before_validation :attach_areas
  
  scope :headquarter, where({ :address_type => :headquarter })
  
  define_index 'company_address' do
    indexes addressable.name, as: :name
    indexes addressable.legal_name, as: :legal_name
    indexes addressable.description
    indexes addressable.user_companies.user.firstname, as: :user_firstnames
    indexes addressable.user_companies.user.lastname, as: :user_lastnames
    indexes locality.title, as: :locality_title
    indexes locality.code, as: :locality_code
    indexes addressable.siret
    indexes addressable.taggings.tag.name, as: :tag_names
    indexes addressable.company_categories.title, :as => :category_title
    
    has addressable_id, as: :company_id
    has locality.id, :as => :locality, :facet => true
    has addressable.company_categories.id, :as => :category, :facet => true
    has addressable.taggings.tag_id, :facet => true, as: 'sectors'
    has addressable.taggings.tag_id, :facet => true, as: 'skills'
    has addressable.taggings.id, facet: true, as: 'taggings'
    has "companies.balance_sheet_number_of_people", :as => :number_of_people, :facet => true, :type => :integer
    has "CRC32(companies.role)", :type => :integer, :as => :role
    
    has addressable.created_at, :sort => true
    
    has "RADIANS(addresses.lat)",  :as => :lat,  :type => :float
    has "RADIANS(addresses.lng)", :as => :lng, :type => :float
    
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
    
    where "addressable_type = 'Company'"
  end
  
  def company?
    addressable.is_a?(Company)
  end
  
  def attach_areas
    if !lat.blank? && !lng.blank?
      geo = Geocoder.search("#{lat}, #{lng}")
    
      datas = {
        :country => geo[0].country,
        :city => geo[0].city,
        :postal_code => geo[0].postal_code
      }
      
      last_parent_id = nil
    
      geo[0].data['address_components'].each do |component|
        if component['types'].include?('administrative_area_level_1')
          datas[:administrative_area] = component['long_name']
        end
        if component['types'].include?('administrative_area_level_2')
          datas[:subadministrative_area] = component['long_name']
        end
      end
    
      write_attribute :country_id, create_or_link_area('Country', datas[:country]).id
      last_parent_id = country_id if last_parent_id.nil?
      
      write_attribute :administrative_area_id, create_or_link_area('AdministrativeArea', datas[:administrative_area], country_id).id
      last_parent_id = administrative_area_id if last_parent_id.nil?
      
      write_attribute :subadministrative_area_id, create_or_link_area('SubadministrativeArea', datas[:subadministrative_area], administrative_area_id).id
      last_parent_id = subadministrative_area_id if last_parent_id.nil?
      
      existing_locality = GeographicArea.where(:area_type => 'Locality', :title => datas[:city], :code => datas[:postal_code]).first
      existing_locality = existing_locality || GeographicArea.create(:area_type => 'Locality', :title => datas[:city], :code => datas[:postal_code], :parent_id => last_parent_id)
      write_attribute :locality_id, existing_locality.id
    end
  end
  
  def title
    str = read_attribute(:title)
    
    if str.blank?
      if address_type == 'headquarter'
        str = "Siège social"
      end
    end
    
    str
  end
  
  protected
  def create_or_link_area(type, str, parent_id = nil)
    area = GeographicArea.where(:area_type => type, :title => str).first
    
    unless area
      area = GeographicArea.create :area_type => type, :title => str, :parent_id => parent_id
    end
    
    area
  end
  
end