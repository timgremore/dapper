require 'net/ldap'
require 'active_support/core_ext'

module Dapper
  module Connection
    
    @@connection = nil
    @@reconnect = true
    
    class << self

      def connection
        if @@connection.nil? || @@reconnect
          @@connection = Net::LDAP.new :host => host,
                                       :base => base,
                                       :auth => { :method => :simple, :username => username, :password => password }
          @@reconnect = false
        end
        @@connection
      end
      
      def authenticate(username, password)
        connection.auth(username, password)
        connection.bind
      end

      def host
        config_value(:host)
      end
      
      def attrs
        config_value(:attrs).split(" ")
      end
      
      def result_set_limit
        config_value(:result_set_limit)
      end
      
      def base
        config_value(:base)
      end
      
      def username
        config_value(:username)
      end
      
      def password
        config_value(:password)
      end
      
      def config
        raise "Please call has_ldap_connection with config options" if @@config.nil?
        @@config
      end
      
      def config_value(key)
        config.fetch(key)
      end

      def configure(opts)
        @@reconnect = true
        Dapper::Connection.parse_configuration(opts)
      end

      def parse_configuration(opts)
        opts = find_credentials(opts).stringify_keys
        @@config = (opts[ENV["RACK_ENV"]] || opts).with_indifferent_access
      end
    
      def find_credentials(opts)
        case opts
        when File
          YAML::load(ERB.new(File.read(opts.path)).result)
        when String, Pathname
          YAML::load(ERB.new(File.read(opts)).result)
        when Hash
          opts
        else
          raise ArgumentError, "Credentials are not a path, file, or hash."
        end
      end

    end
  end
end