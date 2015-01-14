require File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'version')

Gem::Specification.new do |s|
  s.name         = 'mandrill-delivery-method'
  s.summary      = 'Add Mandrill as a deliver method to ActionMailer for Rails apps.'
  s.description  = 'Add Mandrill as a deliver method to ActionMailer for Rails apps.'
  s.version      = MandrillDeliveryMethod::VERSION
  s.platform     = Gem::Platform::RUBY

  s.files        = `find . -type f`.split("\n")
  # s.test_files   = `find . -type f -- {test}/*`.split("\n")
  s.require_path = 'lib'

  s.authors     = ['Mark Oude Veldhuis']
  s.email       = ['mark.oudeveldhuis@nedap.com']
  s.homepage    = 'https://github.com/nedap/mandrill-delivery-method'

  s.add_dependency "mail"
  s.add_dependency "mandrill-api", ">= 1.0.53"

  s.add_development_dependency "webmock"
  s.add_development_dependency "rails"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "codeclimate-test-reporter", ">= 0.4.5"
end
