OauthProviderDemo::Application.routes.draw do
  devise_for :users, :controllers => {:sessions => "users/sessions"}

  match '/oauth/authorize' => 'oauth#authorize'
  match '/oauth/access_token' => 'oauth#access_token'
  match '/oauth/user' => 'oauth#user'
end
