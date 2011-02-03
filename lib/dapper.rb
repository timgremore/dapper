require 'dapper/connection'

module Dapper
  
  def self.included(base)
    base.send :include, Dapper::Connection
    base.extend ClassMethods
  end
  
  module ClassMethods
    def has_ldap_connection(options)
      Dapper::Connection.configure(options)
    end
  end
  
end
