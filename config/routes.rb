Maintenance::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  
  resources :tag_rules

  
  get 'maintenance/autocomplete_target_tag_name', :as => 'autocomplete_target_tag_name'

  match 'parse_manutan' => 'manutan#parse_manutan', :as => "parse_manutan"
  match 'batch_parse_manutan' => 'manutan#batch_parse_manutan', :as => "batch_parse_manutan"
  
  root :to => "maintenance#scan_tag"

  match 'scantag' => 'maintenance#scan_tag', :as => "scantag"
  match 'add_rule' => 'maintenance#add_rule', :as => "add_rule"
  match 'convert_tags' => 'maintenance#convert_tags', :as => "convert_tags"
  match 'add_target_tag' => 'maintenance#add_target_tag', :as => "add_target_tag"
  match 'renametag' => 'maintenance#rename_tag', :as => "renametag"
  match 'removetag' => 'maintenance#remove_tag', :as => "removetag"
  match 'humanize' => 'maintenance#humanize', :as => "humanize"
  match 'update_cache' => 'maintenance#update_cache', :as => "update_cache"
  
end
