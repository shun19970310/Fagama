Rails.application.routes.draw do


  namespace :public do
    get 'rooms/show'
  end
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_scope :customer do
    post "customers/guest_sign_in", to: "public/customers#guest_sign_in"
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: "homes#top"
    resources :customers, only: [:index, :show, :edit, :update]
    resources :comments, only: [:index, :destroy]
    resources :posts, only: [:index, :show, :destroy]
  end

  scope module: :public do
    root to: "homes#top"
    get "homes/about"=>'homes#about'
    resources :customers do
      resource :relationships, only: [:create, :destroy]
      get :followings, on: :member
      get :followers, on: :member
      member do
       get :likes
       get :unsubscribe
       patch :withdraw
      end
    end

    resources :posts do
     resources :comments, only:[:create, :destroy]
     resource :likes, only: [:create,:destroy]
     collection do
      get 'search'
     end
    end

    resources :groups do
      get "join" => "groups#join"
      get "new/mail" => "groups#new_mail"
      get "send/mail" => "groups#send_mail"
    end

    get "search_tag"=>"posts#search_tag"

    get 'posts/search/sort_new', to: 'posts#search', as: 'sort_new'
    get 'posts/search/sort_old', to: 'posts#search', as: 'sort_old'
    get 'posts/search/sort_like', to: 'posts#search', as: 'sort_like'
    get 'posts/search/sort_comment', to: 'posts#search', as: 'sort_comment'

    resources :contacts, only: [:new, :create]

    resources :messages, only: [:create, :destroy]

    resources :rooms, only: [:index, :create,:show]
  end

  get  'index' =>'contacts#index'
  post 'confirm' => 'contacts#confirm'
  post 'done' => 'contacts#done'

end
