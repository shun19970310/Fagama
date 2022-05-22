Rails.application.routes.draw do

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
    resources :customers, only: [:index, :show, :edit, :update]
    resources :comments, only: [:index, :destroy]
  end

  scope module: :public do
    root to: "homes#top"
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

  end

end
