require 'devise'

$: << File.expand_path("..", __FILE__)

require 'devise_custom_rememberable/model'
require 'devise_custom_rememberable/strategy'

Devise.add_module(:custom_rememberable, :strategy => true, :model => "devise_custom_rememberable/model")
