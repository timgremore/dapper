require File.join(File.dirname(__FILE__), "..", "..", "lib", "dapper")

module Helpers
  
  def rebuild_class(options, attr_map = { username: :samaccountname })
    Object.instance_eval { remove_const :Dummy } rescue nil
    Object.const_set("Dummy", Class.new)
    Dummy.class_eval do
      include Dapper
      has_ldap_connection(options, attr_map)
    end
  end

end