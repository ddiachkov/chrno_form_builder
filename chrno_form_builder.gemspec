# encoding: utf-8
$:.push File.expand_path( "../lib", __FILE__ )
require "chrno_form_builder/version"

Gem::Specification.new do |s|
  s.name        = "chrno_form_builder"
  s.version     = ChrnoFormBuilder::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ "Denis Diachkov" ]
  s.email       = [ "d.diachkov@gmail.com" ]
  s.homepage    = "http://larkit.ru"
  s.summary     = "Extended form builder for ActionView"

  s.files        = `git ls-files`.split( "\n" )
  s.require_path = "lib"

  s.add_runtime_dependency "rails", ">= 3.0"
end
