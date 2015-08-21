Rails.application.routes.draw do
  use_doorkeeper
  root  'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :questions do
    resources :answers, only: [:create, :update, :destroy, :vote_up, :vote_down, :cancel_vote]
    resources :comments, :defaults => { :commentable => 'question' }
    member do
      post 'vote_up'
      post 'vote_down'
      delete 'cancel_vote'
      get 'click'
    end
  end

  resources :answers do
    resources :comments, :defaults => { :commentable => 'answer' }
    member do
      patch 'mark_solution'
      post 'vote_up'
      post 'vote_down'
      delete 'cancel_vote'
    end
  end

  resources :attachments

  devise_scope :user do
    post 'email_confirmation', to: 'omniauth_callbacks#email_confirmation'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
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
