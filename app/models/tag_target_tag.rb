class TagTargetTag < ActiveRecord::Base
  validates_uniqueness_of :target_tag_id, :scope => :name
  belongs_to :target_tag
end
