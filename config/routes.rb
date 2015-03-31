MnoEnterprise::Engine.routes.draw do
  
  #============================================================
  # Static Pages
  #============================================================
  root to: redirect('/myspace')
  
  # MySpace routes
  get '/myspace', :to => 'pages#myspace'
  get '/myspace#/apps/dashboard', :to => 'pages#myspace', :as => 'myspace_home'
  get '/myspace#/billing', :to => 'pages#myspace', :as => 'myspace_billing'
  
  #============================================================
  # Devise Configuration
  #============================================================
  devise_for :users, { 
    class_name: "MnoEnterprise::User",
    module: :devise, 
    path_prefix: 'auth',
    controllers: {
      confirmations: "mno_enterprise/auth/confirmations",
      #omniauth_callbacks: "auth/omniauth_callbacks",
      passwords: "mno_enterprise/auth/passwords",
      registrations: "mno_enterprise/auth/registrations",
      sessions: "mno_enterprise/auth/sessions",
      unlocks: "mno_enterprise/auth/unlocks"
    }
  }
  
  # TODO: routing specs
  devise_scope :user do
    get "/auth/users/confirmation/lounge", :to => "auth/confirmations#lounge", as: :user_confirmation_lounge
    patch "/auth/users/confirmation", :to => "auth/confirmations#update"
  end
  
  
  #============================================================
  # JPI V1
  #============================================================
  namespace :jpi do
    namespace :v1 do
      resources :marketplace, only: [:index,:show]
      resource :current_user, only: [:show]
      
      resources :organizations, only: [:index, :show, :update] do
        member do
          put :invite_members
          put :update_member
          put :remove_member
        end
        
        resources :app_instances, only: [:index]
        
        # Currently stubbed
        resources :teams, only: [:index]
      end
    end
  end
end
