Busapp::Application.routes.draw do
  root 'routes#index'

  get '/routes/:id/selection', to: 'routes#selection', as: :route_selection
  post '/routes/:id/selection', to: 'routes#create_user_route', as: :create_user_route
  get '/routes/:id/directions', to: 'routes#directions', as: :route_directions

  get '/userroutes/start_tour', to: 'user_routes#start_tour_info'
  get '/map', to: 'routes#map'
  get '/tour', to: 'route_sequences#tour', as: :tour

  resources :route_sequences, only: [:index, :show]

  get 'landmarks', to: 'audio_clips#index'
  get '/audio_clips', to: 'audio_clips#route_index'

  resources :routes

  devise_for :users, :controllers => {:registrations => 'users', omniauth_callbacks: "omniauth_callbacks"}
  
  devise_scope :user do
    resources :users, only: [] do
      collection do
        get :location, to: "users#set_location"
      end
    end
  end




  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
