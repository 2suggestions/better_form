require File.expand_path("../lib/better_form/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'better_form'
  s.version     = BetterForm::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicholas Firth-McCoy']
  s.email       = ['nicholas@2suggestions.com.au']
  s.homepage    = 'http://github.com/2suggestions/better_form'
  s.summary     = 'A Better Rails 3 FormBuilder'

  s.required_rubygems_version = ">= 1.3.6"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
end
