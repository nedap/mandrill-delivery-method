require 'mail/mandrill'
require 'mandrill-delivery-method/client'
require 'mandrill'

module MandrillDeliveryMethod
  extend self

  def install
    return unless defined?(ActionMailer)
    ActionMailer::Base.add_delivery_method :mandrill, Mail::Mandrill
  end
end

if defined?(Rails)
  require 'mandrill-delivery-method/railtie'
else
  MandrillDeliveryMethod.install
end
