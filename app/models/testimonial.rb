# encoding: utf-8

class Testimonial < ActiveRecord::Base

  belongs_to :company, counter_cache: true
  belongs_to :user_company
  
  validates :company, presence: true
  validates :user_company, presence: true
  validates :body, presence: true
  validates :global_rate, presence: true, inclusion: { in: (1..5) }
  validates :price_rate, presence: true, inclusion: { in: (1..5) }
  validates :reactivity_rate, presence: true, inclusion: { in: (1..5) }
  validates :relational_rate, presence: true, inclusion: { in: (1..5) }
  validates :approach_rate, presence: true, inclusion: { in: (1..5) }
  validates :expertise_rate, presence: true, inclusion: { in: (1..5) }
  validate :author_is_external
  
  after_save :update_company_rate
  after_destroy :save_company_rate
  
  before_save :update_body
  
  define_index do
    indexes body
    has created_at, :sort => true
    has company_id, :as => :company
    has "CASE WHEN created_at >= DATE_ADD(NOW(), INTERVAL -15 DAY) THEN 1 ELSE 0 END", :type => :integer, :as => :two_weeks_old
  end
  
  def author_is_external
    if user_company.user.user_companies.map{|uc| uc.company_id }.include?(company_id)
      errors.add(:company, :invalid)
    end
  end
  
  def update_company_rate
    if company_id_changed? && !company_id_was.blank?
      old_company = Company.find company_id_was
      old_company.update_rates
      old_company.save
      save_company_rate
    else
      [:global, :price, :reactivity, :relational, :approach, :expertise].each do |scope|
        if self.send("#{scope.to_s}_rate_changed?") == true
          save_company_rate
          break
        end
      end
    end
  end
  
  def save_company_rate
    company.update_rates
    company.save
  end

  def update_body
    write_attribute :body_html, (RedCloth.new(body).to_html rescue nil)
  end
  

end