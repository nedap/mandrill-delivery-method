module Mail
  class Mandrill

    def initialize values
      settings = values.dup
      api_key  = settings.delete(:api_key)
      @client  = MandrillRails::Client.new(api_key, settings)
    end

    def deliver! mail
      @client.deliver(mail)
    end

  end
end
