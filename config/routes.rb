Maintenance::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  
  get 'maintenance/autocomplete_target_tag_name', :as => 'autocomplete_target_tag_name'

  
  root :to => "maintenance#scan_tag"

  match 'scantag' => 'maintenance#scan_tag', :as => "scantag"
  match 'add_to_translation_list' => 'maintenance#add_to_translation_list', :as => "add_to_translation_list"
  match 'convert_tags' => 'maintenance#convert_tags', :as => "convert_tags"
  match 'add_target_tag' => 'maintenance#add_target_tag', :as => "add_target_tag"
  match 'renametag' => 'maintenance#rename_tag', :as => "renametag"
  match 'removetag' => 'maintenance#remove_tag', :as => "removetag"
  match 'humanize' => 'maintenance#humanize', :as => "humanize"
  
end
