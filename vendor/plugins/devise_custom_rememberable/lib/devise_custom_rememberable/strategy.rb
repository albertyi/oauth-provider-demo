require 'pp'

class Devise::Strategies::CustomRememberable < Devise::Strategies::Authenticatable
  attr_accessor :password_hash
  
  def valid?
    remember_cookie.present?
  end
  
  def authenticate!
    resource = mapping.to.decode_from_cookie_string(*remember_cookie)
    
    if validate(resource) {resource.validate_against_cookie(remember_cookie)}
      success!(resource)
    else
      pass
    end
  end
  
private
  def success!(resource)
    super
    resource
  end

  def cookie_name
    mapping.to.authentication_cookie_name
  end
  
  def remember_cookie
    @remember_cookie ||= cookies[cookie_name]
  end
end

Warden::Strategies.add(:custom_rememberable, Devise::Strategies::CustomRememberable)
