# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "workon/version"

Gem::Specification.new do |s|
  s.name        = "workon"
  s.version     = Workon::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Wyatt"]
  s.email       = ["wyatt.mike@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}
  
  s.add_dependency "activesupport"
  s.add_development_dependency "rspec"
  
  s.rubyforge_project = "workon"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
