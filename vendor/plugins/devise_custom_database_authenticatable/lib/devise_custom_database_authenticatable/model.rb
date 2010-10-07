require 'digest/sha1'
require 'pp'

module Devise
  module Models
    module CustomDatabaseAuthenticatable
      extend ActiveSupport::Concern
      
      module ClassMethods
        def hash_password(incoming_password, salt)
          Digest::SHA1.hexdigest("#{incoming_password}#{salt}")
        end

        def find_for_custom_database_authentication(conditions)
          find_for_authentication(conditions)
        end
        
        Devise::Models.config(self, :authentication_cookie_name, :authentication_cookie_domain)
      end
      
      def active?
        if !super
          return false
        elsif status != "Active"
          return false
        elsif expiration_date && expiration_date < Date.today
          return false
        else
          return true
        end
      end
      
      def password
        nil
      end
      
      def password=(x)
      end
      
      def inactive_message
        "User is not active"
      end
      
      def valid_password?(incoming_password)
        password_hash == self.class.hash_password(incoming_password, password_salt)
      end
    end
  end
end
