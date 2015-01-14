module MandrillDeliveryMethod
  class Client

    def initialize api_key, settings = nil
      @api_key  = api_key
      @settings = (settings || {}).symbolize_keys
      @mandrill = Mandrill::API.new(@api_key)
    end

    def deliver mail
      raise "Missing recipient" if mail.to.blank?

      mail.ready_to_send!
      message_hash = mail_to_message_hash(mail).merge(text_and_html_parts(mail))
      message_hash['subaccount'] = @settings.delete(:subaccount) if @settings[:subaccount]

      @mandrill.messages.send(message_hash)
    end

    private

    def mail_to_message_hash mail
      delete_blank_fields({
        'from_email' => mail['from'].to_s,
        'from_name'  => mail['from_name'].to_s,
        'to'         => [ { 'email' => mail['to'].to_s } ],
        'subject'    => mail.subject,
        'tag'        => mail['tag'].to_s,
        'headers'    => delete_blank_fields(mail.headers.merge({
          'reply-to' => mail['reply_to'].to_s
        }))
      })
    end

    def text_and_html_parts mail
      text_and_html_parts = if mail.multipart?
        text_part = mail.text_part.to_s
        html_part = mail.html_part.to_s
        {
          text: text_part[text_part.index("\r\n\r\n\r\n")+6..-1],
          html: html_part[html_part.index("\r\n\r\n\r\n")+6..-1]
        }
      else
        { text: mail.body.to_s }
      end
      delete_blank_fields(text_and_html_parts)
    end

    def delete_blank_fields hash
      hash.delete_if { |k, v| v.nil? || (v.respond_to?(:empty?) && v.empty?) }
    end

  end
end
