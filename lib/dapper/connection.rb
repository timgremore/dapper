require 'net/ldap'
require 'active_support/core_ext'

module Dapper
  module Connection
    
    @@connection          = nil
    @@reconnect           = true
    @@username_attr       = :mail
    @@search_method       = :mail
    
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
      
      def authenticate(my_username, password)
        my_filter = "(#{username_attr.to_s}=#{my_username})"
        result = connection.bind_as(
          filter: my_filter,
          password: password
        )
        result ? result.first : false
      end
      
      def get_ldap_entry(criteria)
        ldap_filter = Net::LDAP::Filter.eq(username_attr.to_s, criteria)
        result = connection.search(filter: ldap_filter, size: 1)
        result.respond_to?(:first) ? result.first : result
      end
      
      def username_attr
        @@username_attr
      end
      
      def search_method
        @@search_method
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

      def configure(config, options = {})
        options = {
          username_attr: :mail,
          search_method: :mail
        }.merge(options).symbolize_keys
        @@search_method = options.delete(:search_method)
        @@username_attr = options.delete(:username_attr)
        @@reconnect = true
        Dapper::Connection.parse_configuration(config)
      end

      def parse_configuration(opts)
        opts = find_credentials(opts).stringify_keys
        
        if defined?(Rails)
          @@config = (opts[Rails.env] || opts).symbolize_keys
        elsif defined?(ENV["RACK_ENV"])
          @@config = (opts[ENV["RACK_ENV"]] || opts).symbolize_keys
        else
          @@config = opts.symbolize_keys
        end
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