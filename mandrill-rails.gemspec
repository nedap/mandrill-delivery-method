require File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'version')

Gem::Specification.new do |s|
  s.name         = 'mandrill-rails'
  s.summary      = 'Generate, unpack and parse Hub tokens.'
  s.description  = 'Generate, unpack and parse Hub tokens.'
  s.version      = MandrillRails::VERSION
  s.platform     = Gem::Platform::RUBY

  s.files        = `find . -type f`.split("\n")
  # s.test_files   = `find . -type f -- {test}/*`.split("\n")
  s.require_path = 'lib'

  s.authors     = ['Mark Oude Veldhuis']
  s.email       = ['mark.oudeveldhuis@nedap.com']
  s.homepage    = 'https://github.com/nedap/mandrill-rails'

  s.add_dependency "mandrill"
end
