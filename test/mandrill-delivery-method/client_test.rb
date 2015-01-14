require_relative '../test_helper'

describe MandrillDeliveryMethod::Client do

  describe "#deliver" do

    let(:client) { MandrillDeliveryMethod::Client.new('apikey', {setting: 'value'}) }
    let(:mail) { Minitest::Mock.new }

    before do
      mail.expect :ready_to_send!,  true
      mail.expect :headers,         { some_header: 'some_header_value' }
      mail.expect :[],              "sender@host.tld",     ["from"]
      mail.expect :[],              "Sender Host",         ["from_name"]
      mail.expect :[],              "lucky@receiver.tld",  ["to"]
      mail.expect :[],              "some_tag",            ["tag"]
      mail.expect :[],              "reply@to.tld",        ["reply_to"]
      mail.expect :body,            "mail body"
    end

    it "refuses to send if there is no recipient" do
      mail.expect :to, ""
      assert_raises RuntimeError do
        client.deliver(mail)
      end
    end

    describe "multipart e-mail" do
      before do
        mail.expect :subject,    "Plain text e-mail"
        mail.expect :multipart?, true
        mail.expect :to,         "plain@mail.tld"
        mail.expect :text_part,  "Content-Type: text/plain\r\n\r\n\r\nHere goes the text."
        mail.expect :html_part,  "Content-Type: text/plain\r\n\r\n\r\nHere goes the html."
      end

      it "makes a proper API call" do
        stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
          with(body: "{\"message\":{\"from_email\":\"sender@host.tld\",\"from_name\":\"Sender Host\",\"to\":[{\"email\":\"lucky@receiver.tld\"}],\"subject\":\"Plain text e-mail\",\"tag\":\"some_tag\",\"headers\":{\"some_header\":\"some_header_value\",\"reply-to\":\"reply@to.tld\"},\"text\":\"Here goes the text.\",\"html\":\"Here goes the html.\"},\"async\":false,\"ip_pool\":null,\"send_at\":null,\"key\":\"apikey\"}").
          to_return(status: 200, body: "{\"status\":\"sent\"}", headers: {})

        result = client.deliver(mail)
        assert_instance_of Hash, result
        assert_equal "sent", result["status"]
      end
    end

    describe "plain text e-mail" do
      before do
        mail.expect :subject,    "Cozy e-mail"
        mail.expect :multipart?, false
      end

      it "makes proper API call" do
        mail.expect :to, "some@email.tld"

        stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
          with(body: "{\"message\":{\"from_email\":\"sender@host.tld\",\"from_name\":\"Sender Host\",\"to\":[{\"email\":\"lucky@receiver.tld\"}],\"subject\":\"Cozy e-mail\",\"tag\":\"some_tag\",\"headers\":{\"some_header\":\"some_header_value\",\"reply-to\":\"reply@to.tld\"},\"text\":\"mail body\"},\"async\":false,\"ip_pool\":null,\"send_at\":null,\"key\":\"apikey\"}").
          to_return(status: 200, body: "{\"status\":\"sent\"}", headers: {})

        result = client.deliver(mail)
        assert_instance_of Hash, result
        assert_equal "sent", result["status"]
      end
    end

  end

end
