# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'geoip-rails/version'

Gem::Specification.new do |s|
  s.name        = 'geoip-rails'
  s.version     = Geoip::Rails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Priit Haamer']
  s.email       = ['priit@fraktal.ee']
  s.homepage    = 'https://github.com/priithaamer/geoip-rails'
  s.summary     = %q{MySQL database backed interface to MaxMind's GeoLite City GeoIP information}
  s.description = %q{Provides ultra-fast access to GeoIP database through Rails models}

  s.rubyforge_project = 'geoip-rails'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
