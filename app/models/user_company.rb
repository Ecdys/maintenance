class UserCompany < ActiveRecord::Base
  
  attr_accessible :user, :company
  
  acts_as_list scope: :company_id
  default_scope order('position asc')
  
  attr_accessor :email
  attr_accessible :email, :user_id, :company_id, :job_title, :role, :position
  
  belongs_to :user
  belongs_to :company
  
  has_many :testimonials
  has_many :proposals
  
  validates :role, presence: true, inclusion: { in: %w(user admin) }
  validates :user_id, presence: true, uniqueness: { scope: :company_id }
  validates :company_id, presence: true
  validates :job_title, presence: true
  
  before_destroy :has_no_related_datas
  
  def has_no_related_datas
    proposals.count == 0 && testimonials.count == 0
  end

end
