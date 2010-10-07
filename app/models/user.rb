class User < ActiveRecord::Base
  before_validation :initialize_fields, :on => :create
  devise :token_authenticatable, :custom_database_authenticatable
  self.token_authentication_key = "access_token"
  self.authentication_cookie_name = "authentication_cookie"
  self.authentication_cookie_domain = nil
  has_many :access_grants

  def self.find_for_token_authentication(conditions)
    where(["access_grants.access_token = ? AND (access_grants.access_token_expires_at IS NULL OR access_grants.access_token_expires_at > ?)", conditions[token_authentication_key], Time.now]).joins(:access_grants).select("users.*").first
  end
  
  def initialize_fields
    self.status = "Active"
    self.expiration_date = 1.year.from_now
  end
end
