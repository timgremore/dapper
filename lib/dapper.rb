require 'dapper/connection'

module Dapper
  
  def self.included(base)
    base.send :include, Dapper::Connection
    base.extend ClassMethods
  end
  
  module ClassMethods
    def has_ldap_connection(options)
      self.instance_eval do
        def ldap_connection
          Dapper::Connection.connection
        end
        
        def valid_ldap_credentials?(username, password)
          Dapper::Connection.authenticate(username, password)
        end
      end
      Dapper::Connection.configure(options)
    end
  end
  
end
