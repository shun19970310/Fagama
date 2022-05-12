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
  end

  scope module: :public do
    root to: "homes#top"
    get 'home/about' => 'homes#about', as: 'about'
    resources :customers, only: [:show, :edit, :update]
    get 'customers/unsubscribe'
    patch 'customers/withdraw'
    resources :posts do
     resources :comments, only:[:create, :destroy]
     resource :likes, only: [:create,:destroy]
    end

    resources :groups do
      get "join" => "groups#join"
    end
  end



end
