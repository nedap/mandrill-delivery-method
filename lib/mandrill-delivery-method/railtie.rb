module MandrillDeliveryMethod
  class Railtie < Rails::Railtie
    initializer 'mandrill-delivery-method', before: 'action_mailer.set_configs' do
      ActiveSupport.on_load :action_mailer do
        MandrillDeliveryMethod.install
      end
    end
  end
end
