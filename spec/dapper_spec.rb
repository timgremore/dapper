require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Dapper" do
  it "should raise exception without configuration set" do
    expect{ rebuild_model }.to raise_error(StandardError)
  end
  
  it "should not raise exception with configuration set" do
    rebuild_class(host: "1.2.3.4", base: "ab.cd", port: 389, username: "admin", password: "secret")
    
    Dapper::Connection.connection.host.should eql("1.2.3.4")
    Dapper::Connection.connection.port.should eql(389)
    Dapper::Connection.connection.base.should eql("ab.cd")
    Dapper::Connection.username.should eql("admin")
    Dapper::Connection.password.should eql("secret")
  end
end
