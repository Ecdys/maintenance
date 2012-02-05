class GeographicArea < ActiveRecord::Base
  acts_as_nested_set
  
  validates :title, :presence => true
  validates :area_type, :presence => true
  
  before_save :set_lat_lng
  
  define_index do
    indexes title
    
    has "CRC32(area_type)", :type => :integer, :as => :role
  end
  
  sphinx_scope(:ts_localities){
    { :conditions => { :area_type => 'Locality'.to_crc32 } }
  }
  
  scope :localities, where({ :area_type => 'Locality' })
  
  def set_lat_lng
    if lat.blank? || lng.blank?
      
      if area_type == "Country"
        str = title
      elsif area_type == "AdministrativeArea"
        str = "#{title}, #{parent_by_type('Country').try(:title)}"
      elsif area_type == "SubadministrativeArea"
        str = "#{title}, #{parent_by_type('Country').try(:title)}"
      elsif area_type == "Locality"
        str = "#{title}, #{code}, #{parent_by_type('Country').try(:title)}"
      else
        str = ""
      end
      
      geo = Geocoder.search str
      
      write_attribute :lat, geo[0].geometry['location']['lat']
      write_attribute :lng, geo[0].geometry['location']['lng']
      
    end
  end
  
  def parent_by_type(type)
    parent_area = parent
    while parent_area != nil
      if parent_area.area_type == type
        break
      else
        parent_area = parent_area.parent
      end
    end
    parent_area
  end
  
end