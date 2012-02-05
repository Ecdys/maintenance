class List < ActiveRecord::Base
  
  belongs_to :company
  has_and_belongs_to_many :companies, :join_table => 'list_companies', :uniq => true
  
  validates :title, :presence => true
  validates :company, :presence => true
  
  before_save :update_companies_counter
  
  scope :standard, where({ list_type: :standard })
  
  def update_companies_counter
    write_attribute :companies_counter, companies.count
  end
  
end
