Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # namespace :admin do
  #   root "dashboard#index"
  #   resources :users, only: [:index, :show]
  #   resources :orders, only: [:update]
  #   resources :merchants, only: [:index, :show, :update]
  #   namespace :merchants do
  #     scope '/:merchant_id/' do
  #       resources :items, except: [:show]
  #     end
  #   end
  # end

  get '/admin', to: 'admin/dashboard#index', as: 'admin_root'
  get '/admin/users', to: 'admin/users#index', as: 'admin_users'
  get '/admin/users/:id', to: 'admin/users#show', as: 'admin_user'
  patch  '/admin/orders/:id', to: 'admin/orders#update', as: 'admin_order'
  put  '/admin/orders/:id', to: 'admin/orders#update'
  get '/admin/merchants', to: 'admin/merchants#index', as: 'admin_merchants'
  get '/admin/merchants/:id', to: 'admin/merchants#show', as: 'admin_merchant'
  patch '/admin/merchants/:id', to: 'admin/merchants#update'
  put '/admin/merchants/:id', to: 'admin/merchants#update'
  get '/admin/merchants/:merchant_id/items', to: 'admin/merchants/items#index', as: 'admin_merchants_items'
  post '/admin/merchants/:merchant_id/items', to: 'admin/merchants/items#create'
  get '/admin/merchants/:merchant_id/items/new', to: 'admin/merchants/items#new', as: 'new_admin_merchants_item'
  get '/admin/merchants/:merchant_id/items/:id/edit', to: 'admin/merchants/items#edit', as: 'edit_admin_merchants_item'
  patch '/admin/merchants/:merchant_id/items/:id', to: 'admin/merchants/items#update', as: 'admin_merchants_item'
  put '/admin/merchants/:merchant_id/items/:id', to: 'admin/merchants/items#update'
  delete '/admin/merchants/:merchant_id/items/:id', to: 'admin/merchants/items#destroy'

# namespace :merchant do
#   root 'dashboard#index'
#   resources :items, except: [:show]
#   get '/orders/:order_id', to: "orders#show"
#   patch '/orders/:order_id', to: "orders#update"
#   resources :discounts, except: [:show]
# end

  get '/merchant', to: 'merchant/dashboard#index', as: 'merchant_root'
  get '/merchant/items', to: 'merchant/items#index', as: 'merchant_items'
  post '/merchant/items', to: 'merchant/items#create'
  get '/merchant/items/new', to: 'merchant/items#new', as: 'new_merchant_item'
  get '/merchant/items/:id/edit', to: 'merchant/items#edit', as: 'edit_merchant_item'
  patch '/merchant/items/:id', to: 'merchant/items#update', as: 'merchant_item'
  put '/merchant/items/:id', to: 'merchant/items#update'
  delete '/merchant/items/:id', to: 'merchant/items#destroy'

  get '/merchant/orders/:order_id', to: 'merchant/orders#show', as: 'merchant'
  patch '/merchant/orders/:order_id', to: 'merchant/orders#update'

  get '/merchant/discounts', to: 'merchant/discounts#index', as: 'merchant_discount'
  post '/merchant/discounts', to: 'merchant/discounts#create'
  get '/merchant/discounts/new', to: 'merchant/discounts#new', as: 'new_merchant_discount'
  get '/merchant/discounts/:id/edit', to: 'merchant/discounts#edit'
  patch '/merchant/discounts/:id', to: 'merchant/discounts#update'
  put '/merchant/discounts/:id', to: 'merchant/discounts/#update'
  delete 'merchant/discounts/:id', to: 'merchant/discounts/#destroy'

  #resources :merchants, except: [:delete]
  get '/merchants', to: 'merchants#index', as: 'merchants'
  post '/merchants', to: 'merchants#create'
  get '/merchants/new', to: 'merchants#new', as: 'new_merchant'
  get '/merchants/:id/edit', to: 'merchants#edit', as: 'edit_merchant'
  get '/merchants/:id', to: 'merchants#show'
  patch '/merchants/:id', to: 'merchants#update'
  put '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'
  get '/merchants/:merchant_id/items', to: 'items#index'


  #resources :items, only: [:index, :show]
  get '/items', to: 'items#index', as: 'items'
  get '/items/:id', to: 'items#show', as: 'item'
  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  #resources :reviews, only: [:edit, :update]
  get '/reviews/:id/edit', to: 'reviews#edit', as: 'edit_review'
  patch '/reviews/:id', to: 'reviews#update', as: 'review'
  put '/reviews/:id', to: 'reviews#update'
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#create"
  patch "/cart/:item_id", to: "cart#update"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#destroy"
  delete "/cart/:item_id", to: "cart#destroy"

  # namespace :profile do
  #   get "/orders", to: "orders#index"
  #   get "/orders/:id", to: "orders#show", as: "order_show"
  #   patch "/orders/:id", to: "orders#update", as: "order_cancel"
  # end

  get "/profile/orders", to: "profile/orders#index"
  get "/profile/orders/:id", to: "profile/orders#show", as: "order_show"
  patch "/profile/orders/:id", to: "profile/orders#update", as: "order_cancel"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"

  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
end
