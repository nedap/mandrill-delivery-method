require File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'version')

Gem::Specification.new do |s|
  s.name         = 'mandrill-delivery-method'
  s.summary      = 'Add Mandrill as a deliver method to ActionMailer for Rails apps.'
  s.description  = 'Add Mandrill as a deliver method to ActionMailer for Rails apps.'
  s.version      = MandrillDeliveryMethod::VERSION
  s.platform     = Gem::Platform::RUBY

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'

  s.authors     = ['Mark Oude Veldhuis']
  s.email       = ['mark.oudeveldhuis@nedap.com']
  s.homepage    = 'https://github.com/nedap/mandrill-delivery-method'

  s.add_runtime_dependency "mail",         "~> 2.6"
  s.add_runtime_dependency "mandrill-api", "~> 1.0", ">= 1.0.53"

  s.add_development_dependency "webmock",                   "~> 1.20"
  s.add_development_dependency "rails",                     "~> 4.0"
  s.add_development_dependency "guard-minitest",            "~> 2.4"
  s.add_development_dependency "guard",                     "~> 2.11"
  s.add_development_dependency "codeclimate-test-reporter", "~> 0.4", ">= 0.4.5"
end
