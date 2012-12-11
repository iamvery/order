# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'order/version'

Gem::Specification.new do |s|
  s.name        = 'order'
  s.version     = Order::Version
  s.authors     = ['Jay Hayes']
  s.email       = 'ur@iamvery.com'
  s.homepage    = 'http://github.com/iamvery/order'
  s.summary     = %q(DSL for defining ActiveRecord orderings)
  s.description = %q(Provides a simple DSL for creating named scopes for ordering records)

  s.files         = `git ls-files`.split "\n"
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split "\n"
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '~> 3.2'
end
