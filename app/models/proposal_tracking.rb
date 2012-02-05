class ProposalTracking < ActiveRecord::Base
  
  attr_accessible :company_id, :proposal_id, :state
  
  belongs_to :proposal
  belongs_to :company
  
  validates :proposal, :presence => true
  validates :company, :presence => true
  
  scope :pending, where({ state: :pending })
  
  define_index do
    indexes company.name
    has created_at, sort: true
    has company_id, :as => :company
    has "CASE WHEN proposal_trackings.created_at >= DATE_ADD(NOW(), INTERVAL -15 DAY) THEN 1 ELSE 0 END", :type => :integer, :as => :two_weeks_old
  end
  
  state_machine :state, :initial => :pending do
    event :read do
      transition :pending => :read
    end
    before_transition :on => :read, :do => :mark_as_read
    
    event :accept do
      transition [:pending, :read] => :accepted
    end
    before_transition :on => :accept, :do => :mark_as_accepted
    
    event :reject do
      transition [:pending, :read] => :rejected
    end
    before_transition :on => :reject, :do => :mark_as_rejected
    
    state :read
  end
  
  def mark_as_read
    write_attribute :read_at, Time.now
  end
  
  def mark_as_accepted
    write_attribute :accepted, true
    write_attribute :accepted_at, Time.now
  end
  
  def mark_as_rejected
    write_attribute :accepted, false
    write_attribute :accepted_at, Time.now
  end

end