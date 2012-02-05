Maintenance::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => "maintenance#scan_tag"

  match 'scantag' => 'maintenance#scan_tag', :as => "scantag"
  match 'add_to_translation_list' => 'maintenance#add_to_translation_list', :as => "add_to_translation_list"
  match 'convert_tags' => 'maintenance#convert_tags', :as => "convert_tags"
  match 'add_target_tag' => 'maintenance#add_target_tag', :as => "add_target_tag"
  match 'renametag' => 'maintenance#rename_tag', :as => "renametag"
  match 'removetag' => 'maintenance#remove_tag', :as => "removetag"
  match 'humanize' => 'maintenance#humanize', :as => "humanize"
  
end
