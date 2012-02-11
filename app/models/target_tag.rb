class TargetTag < ActiveRecord::Base
  has_many :tag_rules, :dependent => :destroy
  
end
