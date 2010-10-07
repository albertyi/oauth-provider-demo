require 'devise'

$: << File.expand_path("..", __FILE__)

require 'devise_custom_database_authenticatable/model'
require 'devise_custom_database_authenticatable/strategy'
require 'devise_custom_database_authenticatable/routes'

Devise.add_module(:custom_database_authenticatable, :strategy => true, :model => "devise_custom_database_authenticatable/model", :route => true)
