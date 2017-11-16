Rails.application.routes.draw do
  #devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :questions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
