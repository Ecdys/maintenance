class Picture < ActiveRecord::Base
  
  default_scope order('position asc')
  
  belongs_to :pictureable, :polymorphic => true
  
  validates :pictureable, :presence => true
  validates :file, :presence => true
  
  acts_as_list :scope => :pictureable
  
  mount_uploader :file, PictureUploader
  
end
