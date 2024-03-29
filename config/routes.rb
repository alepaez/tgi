TgiCrm::Application.routes.draw do
  root to: 'application#index'

  get 'app(/*path)' => 'application#app', as: :app

  namespace :api do
    namespace :v1 do

      get  'contacts' => 'contact#index'
      post  'contacts' => 'contact#create'
      get  'contacts/:id' => 'contact#show'
      put  'contacts/:id' => 'contact#update'
      delete  'contacts/:id' => 'contact#destroy'
      get  'contacts/:id/strategic_information' => 'contact#strategic_information'

      get  'products' => 'product#index'
      post  'products' => 'product#create'
      get  'products/:id' => 'product#show'
      put  'products/:id' => 'product#update'
      delete  'products/:id' => 'product#destroy'

      get  'deals' => 'deal#index'
      post  'deals' => 'deal#create'
      get  'deals/:id' => 'deal#show'
      put  'deals/:id' => 'deal#update'
      delete  'deals/:id' => 'deal#destroy'

      get 'dashboard/recent_income' => 'dashboard#recent_income'
      get 'dashboard/last_12_weeks_income_comparison' => 'dashboard#last_12_weeks_income_comparison'
      get 'dashboard/top_products_deals' => 'dashboard#top_products_deals'
      
    end
  end

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
