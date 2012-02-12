class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  define_index do
    indexes name
  end
end