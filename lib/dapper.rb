require 'dapper/connection'

module Dapper
  
  def self.included(base)
    base.send :include, Dapper::Connection
    base.extend ClassMethods
  end
  
  module ClassMethods
    def has_ldap_connection(config, options = { })
      options = {
        username: :mail,
        search_method: :mail
      }.merge(options)

      self.instance_eval do
        def ldap_connection
          Dapper::Connection.connection
        end
        
        def valid_ldap_credentials?(username, password)
          Dapper::Connection.authenticate(username, password)
        end
      end
      
      self.class_eval do
        def ldap_entry
          @ldap_entry ||= Dapper::Connection.get_ldap_entry(self.send(Dapper::Connection.search_method.to_sym))
        end
      end
      
      Dapper::Connection.configure(config, options)
    end
  end
  
end
