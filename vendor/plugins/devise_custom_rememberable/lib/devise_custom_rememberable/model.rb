module Devise
  module Models
    module CustomRememberable
      extend ActiveSupport::Concern
      
      module ClassMethods
        Devise::Models.config(self, :authentication_cookie_name)

        def decode_from_cookie_string(cookie_string)
          # clearly this is not secure, just for demonstration purposes
          username, password_hash = cookie_string.split(/,/)
          where(["username = ? AND password_hash = ?", username, password]).first
        end
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
    end
  end
end
