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
        'to'         => build_recipients(mail, 'to') +
                        build_recipients(mail, 'cc') +
                        build_recipients(mail, 'bcc'),
        'subject'    => mail.subject,
        'tags'       => Array(mail['tag'].to_s).delete_if(&:empty?),
        'headers'    => delete_blank_fields(mail.headers.merge({
          'reply-to' => mail['reply_to'].to_s
        }))
      })
    end

    def text_and_html_parts mail
      delete_blank_fields({
        text: text_part(mail),
        html: html_part(mail)
      })
    end

    def is_text? mail
      mail.has_content_type? ? !!(mail.main_type =~ /^text$/i) : false
    end

    def is_html? mail
      is_text?(mail) && !!(mail.sub_type =~ /^html$/i)
    end

    def text_part mail
      if mail.multipart? && mail.text_part
        mail.text_part.decoded
      elsif is_text?(mail) && !is_html?(mail)
        mail.decoded
      elsif !is_html?(mail)
        mail.text_part.decoded
      end
    end

    def html_part mail
      if mail.multipart? && mail.html_part
        mail.html_part.decoded
      elsif is_html?(mail)
        mail.decoded
      end
    end

    def build_recipients mail, recipient_type
      return [] unless mail[recipient_type]
      formatted = mail[recipient_type].formatted
      mandrill_recipients = formatted.map do |address|
        address = Mail::Address.new(address)
        delete_blank_fields({
          email: address.address,
          name: address.display_name,
          type: recipient_type
        })
      end
    end

    def delete_blank_fields hash
      hash.delete_if { |k, v| v.nil? || (v.respond_to?(:empty?) && v.empty?) }
    end

  end
end
