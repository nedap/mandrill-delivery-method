module MandrillRails
  class Railtie < Rails::Railtie
    initializer 'mandrill-rails', before: 'action_mailer.set_configs' do
      ActiveSupport.on_load :action_mailer do
        MandrillRails.install
      end
    end
  end
end
