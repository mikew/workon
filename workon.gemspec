# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "workon/version"

Gem::Specification.new do |s|
  s.name        = "workon"
  s.version     = Workon::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Wyatt"]
  s.email       = ["wyatt.mike@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Runs actions based on directories}
  s.description = %q{Runs actions based on directories}

  s.add_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent" if RUBY_PLATFORM =~ /darwin/

  s.rubyforge_project = "workon"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
