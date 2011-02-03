require File.join(File.dirname(__FILE__), "..", "..", "lib", "dapper")

module Helpers
  
  def rebuild_class(options = {})
    Object.instance_eval { remove_const :Dummy } rescue nil
    Object.const_set("Dummy", Class.new)
    Dummy.class_eval do
      include Dapper
      has_ldap_connection(options)
    end
  end

end