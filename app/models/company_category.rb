class CompanyCategory < ActiveRecord::Base
  
  validates :title, :presence => true
  
  has_and_belongs_to_many :companies, :join_table => 'companies_categories'

end