require 'pp'

class Devise::Strategies::CustomDatabaseAuthenticatable < Devise::Strategies::Authenticatable
  def authenticate!
    resource = valid_password? && mapping.to.find_for_custom_database_authentication(authentication_hash)
    
    if validate(resource) {resource.valid_password?(password)}
      save_to_cookie(resource)
      success!(resource)
    else
      fail(:invalid)
    end
  end

  def cookie_name
    mapping.to.authentication_cookie_name
  end
  
  def convert_resource_into_cookie(resource)
    "#{resource.username},#{resource.password_hash}"
  end

  def save_to_cookie(resource)
    if remember_password?
      cookie_string = convert_resource_into_cookie(resource)
      cookies[cookie_name] = {:value => cookie_string, :domain => mapping.to.authentication_cookie_domain, :expires => 1.day.from_now}
    end
  end
  
  def remember_password?
    @remember_password ||= params[:user].delete(:remember_password)
  end
end

Warden::Strategies.add(:custom_database_authenticatable, Devise::Strategies::CustomDatabaseAuthenticatable)
