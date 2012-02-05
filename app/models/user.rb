class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable    
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :avatar, :avatar_cache, :addresses_attributes, :description, :twitter, :facebook, :linkedin, :website
  
  attr_accessible :cgv
  
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :cgv, :acceptance => true, :on => :create
  
  has_many :user_companies, :dependent => :destroy
  has_many :companies, :through => :user_companies
  
  has_many :addresses, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :addresses, :reject_if => proc {|attrs| attrs['country'].nil? && attrs['locality'].nil? && attrs['street'].blank? && attrs['phone'].blank? && attrs['mobile_phone'].blank? && attrs['fax'].blank? && attrs['email'].blank? && attrs['website'].blank? }, :allow_destroy => true
  
  mount_uploader :avatar, AvatarUploader
  
  before_save :update_description
  
  def full_name
    "#{firstname} #{lastname}"
  end
  
  def update_with_password(params={})
    params.delete(:current_password)
    self.update_without_password(params)
  end
  
  def update_description
    write_attribute :description_html, (RedCloth.new(description).to_html rescue nil)
  end
  
  def website=(str)
    write_attribute :website, str.gsub('http://', '')
  end
  
end
