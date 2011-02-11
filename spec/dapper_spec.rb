require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Dapper" do
  it "should raise exception without configuration set" do
    expect{ rebuild_model }.to raise_error(StandardError)
  end
  
  it "should accept configuration as a hash" do
    rebuild_class(host: "1.2.3.4", base: "ab.cd", port: 389, username: "admin", password: "secret")
    
    Dummy.ldap_connection.should be(Dapper::Connection.connection)
    
    Dapper::Connection.connection.host.should eql("1.2.3.4")
    Dapper::Connection.connection.port.should eql(389)
    Dapper::Connection.connection.base.should eql("ab.cd")
    Dapper::Connection.username.should eql("admin")
    Dapper::Connection.password.should eql("secret")
  end
  
  it "should accept configuration as a path to a yml file" do
    yml = <<-YML
      host: "4.3.2.1"
      base: "ab.cd"
      port: 389
      username: "admin"
      password: "secret"
    YML
    
    File.open("config.yml", "w+") { |f| f.write(yml) }
    
    rebuild_class("config.yml")
    
    File.delete("config.yml")
    
    Dummy.ldap_connection.should be(Dapper::Connection.connection)
    
    Dapper::Connection.connection.host.should eql("4.3.2.1")
    Dapper::Connection.connection.port.should eql(389)
    Dapper::Connection.connection.base.should eql("ab.cd")
    Dapper::Connection.username.should eql("admin")
    Dapper::Connection.password.should eql("secret")
  end
  
  it "should return true with live ldap and ldap.yml file" do
    rebuild_class("ldap.yml")
    
    Dummy.valid_ldap_credentials?("LSSUser1", "nwtc123").should be_true
  end
  
  it "should return false with live ldap and ldap.yml" do
    rebuild_class("ldap.yml")
    
    Dummy.valid_ldap_credentials?("invalid", "user").should be_false
  end
  
  it "should return true with live ldap and ldap.yml file containing environments set as RACK_ENV" do
    ENV["RACK_ENV"] = "development"
    
    rebuild_class("ldap_with_env.yml")
    
    Dummy.valid_ldap_credentials?("LSSUser1", "nwtc123").should be_true
  end  
end
