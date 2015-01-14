require 'mail/mandrill'
require 'mandrill-rails/client'
require 'mandrill'

module MandrillRails
  extend self

  def install
    ActionMailer::Base.add_delivery_method :mandrill, Mail::Mandrill
  end
end

if defined?(Rails)
  require 'mandrill-rails/railtie'
else
  MandrillRails.install
end
