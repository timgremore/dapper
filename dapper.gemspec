# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dapper/version"

Gem::Specification.new do |s|
  s.name        = "dapper"
  s.version     = Dapper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Gremore"]
  s.email       = ["timgremore@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Basic ldap authentication library}
  s.description = %q{}

  s.rubyforge_project = "dapper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "activesupport"
  s.add_dependency "net-ldap"
  # s.add_dependency "i18n"
  s.add_development_dependency "rspec"
end
