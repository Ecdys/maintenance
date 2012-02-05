class BalanceSheet < ActiveRecord::Base

  belongs_to :company
  
  after_save :update_company
  
  validates :year, :presence => true, :numericality => true, :uniqueness => { :scope => :company_id }
  validates :sales, :presence => true, :numericality => true
  validates :number_of_people, :presence => true, :numericality => true
  validates :company, :presence => true
  
  def update_company
    company.save
  end
  
end