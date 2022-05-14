Rails.application.routes.draw do

  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: "homes#top"
    resources :customers, only: [:index, :show, :edit, :update]
  end

  scope module: :public do
    root to: "homes#top"
    get 'home/about' => 'homes#about', as: 'about'
    resources :customers, only: [:show, :edit, :update] do
      member do
       get :likes
      end
    end
    get 'customers/unsubscribe'
    patch 'customers/withdraw'
    resources :posts do
     resources :comments, only:[:create, :destroy]
     resource :likes, only: [:create,:destroy]
     collection do
      get 'search'
     end
    end

    resources :groups do
      get "join" => "groups#join"
    end

    post '/guests/guest_sign_in', to: 'guests#new_guest'

    get "search_tag"=>"posts#search_tag"

  end



end
