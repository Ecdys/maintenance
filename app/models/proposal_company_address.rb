class ProposalCompanyAddress < ActiveRecord::Base

  belongs_to :proposal
  belongs_to :address
  
  define_index do
    indexes proposal.summary
    indexes proposal.description
    indexes proposal.user_company.user.firstname, as: :user_firstname
    indexes proposal.user_company.user.lastname, as: :user_lastname
    indexes proposal.user_company.company.name, as: :company_name
    indexes proposal.company_addresses.locality.title, as: :locality_title
    indexes proposal.company_addresses.locality.code, as: :locality_code
    indexes proposal.taggings.tag.name, as: :tag_names
    indexes proposal.company_categories.title, :as => :category_title
    
    has proposal.created_at, :sort => true
    has proposal.start_at, :sort => true
    has proposal.end_at, :sort => true
    
    has "CASE WHEN proposals.start_at <= NOW() AND proposals.end_at > NOW() THEN 1 ELSE 0 END", :type => :integer, :as => :current
    has "CASE WHEN proposals.start_at <= NOW() AND proposals.end_at < NOW() THEN 1 ELSE 0 END", :type => :integer, :as => :archived
    has proposal.public
    
    has address.locality.id, :as => :locality, :facet => true
    has proposal.taggings.tag_id, :as => :tags, :facet => true
    has proposal.taggings.tag_id, :as => :skills, :facet => true
    has proposal.taggings.tag_id, :as => :sectors, :facet => true
    has proposal.taggings.id, :as => :taggings, :facet => true
    has proposal.company_categories.id, :as => :category, :facet => true
    
    has "RADIANS(addresses.lat)",  :as => :lat,  :type => :float
    has "RADIANS(addresses.lng)", :as => :lng, :type => :float
    
    set_property field_weights: {
      summary:          10,
      company_name:     8,
      tag_names:        5,
      locality_title:   5,
      locality_code:    5,
      category_title:   2,
      user_firstname:   2,
      user_lastname:    2
    }
  end
  
  sphinx_scope(:ts_current) {
    { :with => { :current => 1 } }
  }
  
  sphinx_scope(:ts_archived) {
    { :with => { :archived => 1 } }
  }
  
  sphinx_scope(:ts_public) {
    { :with => { :public => 1 } }
  }
  
end
