# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".
Quienmanda::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }, :skip => [:sessions]
  devise_scope :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  # Add user profile page
  resources :users, :only => [:show]

  get '/admin/import' => 'import#index', :as => 'import_index'
  post '/admin/import/upload' => 'import#upload', :as => 'import_upload'
  get '/admin/import/process' => 'import#process_facts', :as => 'import_process'

  post '/admin/commit' => 'import#commit'
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :posts, only: [:index, :show] do
    collection do
      get 'feed', :as => :feed, :defaults => { :format => 'atom' }
    end
    collection do
      get 'tagged/:tag_name', :action => 'tagged', :as => 'tagged'
    end
  end

  resources :people, only: [:index, :show]

  resources :organizations, only: [:index, :show]

  resources :photos, only: [:index, :show] do
    resources :annotations, :except => [:new, :edit]
    member do
      get 'next'
      get 'previous'
    end
    collection do
      get 'tagged/:tag_name', :action => 'tagged', :as => 'tagged'
      post ':id/vote-up', :action => 'vote_up', :as => 'vote_up'
      post ':id/vote-down', :action => 'vote_down', :as => 'vote_down'
    end
  end

  post 'photos' => 'photos#create', :as => 'photos_create'

  resources :topics, only: [:index, :show]

  # Global search
  get '/search' => 'search#search', :as => 'search'

  # We add 'index' for the autocomplete in annotations
  # We add 'show' so ShowInApp works in Rails Admin
  resources :entities, only: [:index, :show]

  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

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
