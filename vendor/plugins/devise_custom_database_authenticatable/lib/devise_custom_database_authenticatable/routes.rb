ActionController::Routing::Mapper.class_eval do
  protected
    alias_method :devise_custom_database_authenticatable, :devise_session
end
