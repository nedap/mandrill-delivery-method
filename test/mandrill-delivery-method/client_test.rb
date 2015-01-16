require_relative '../test_helper'

describe MandrillDeliveryMethod::Client do

  describe "#deliver" do

    let(:client) { MandrillDeliveryMethod::Client.new('apikey', {setting: 'value'}) }

    it "includes tags assigned to e-mails" do
      mail = Mail.new do
        from "some@sender.tld"
        to "lucky@received.tld"
        subject "a subject"
      end.tap do |mail|
        mail['tag'] = "some_tag"
      end

      stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
        with(:body => "{\"message\":{\"from_email\":\"some@sender.tld\",\"to\":[{\"email\":\"lucky@received.tld\",\"type\":\"to\"}],\"subject\":\"a subject\",\"tags\":[\"some_tag\"]},\"async\":false,\"ip_pool\":null,\"send_at\":null,\"key\":\"apikey\"}",
             :headers => {'Content-Type'=>'application/json', 'Host'=>'mandrillapp.com:443', 'User-Agent'=>'excon/0.43.0'}).
        to_return(:status => 200, :body => {status:"sent"}.to_json, :headers => {})

      result = client.deliver(mail)
      assert_instance_of Hash, result
      assert_equal "sent", result["status"]
    end

    it "sends the proper API call for text-only e-mails" do
      mail = Mail.new do
        from    "some@sender.tld"
        to      "luck@receiver.tld"
        subject "only text mail"
        body    "just plain text body"
      end

      stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
        with(:body => "{\"message\":{\"from_email\":\"some@sender.tld\",\"to\":[{\"email\":\"luck@receiver.tld\",\"type\":\"to\"}],\"subject\":\"only text mail\",\"text\":\"just plain text body\"},\"async\":false,\"ip_pool\":null,\"send_at\":null,\"key\":\"apikey\"}",
             :headers => {'Content-Type'=>'application/json', 'Host'=>'mandrillapp.com:443', 'User-Agent'=>'excon/0.43.0'}).
        to_return(:status => 200, :body => {status:"sent"}.to_json, :headers => {})

      result = client.deliver(mail)
      assert_instance_of Hash, result
      assert_equal "sent", result["status"]
    end

    it "sends the proper API call for html-only e-mails" do
      mail = Mail.new do
        from    "some@sender.tld"
        to      "luck@receiver.tld"
        subject "only html mail"
        html_part do
          content_type 'text/html; charset=UTF-8'
          "<html><head></head><body>This is HTML.</body></html>"
        end
      end

      stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
        with(:body => "{\"message\":{\"from_email\":\"some@sender.tld\",\"to\":[{\"email\":\"luck@receiver.tld\",\"type\":\"to\"}],\"subject\":\"only html mail\"},\"async\":false,\"ip_pool\":null,\"send_at\":null,\"key\":\"apikey\"}",
             :headers => {'Content-Type'=>'application/json', 'Host'=>'mandrillapp.com:443', 'User-Agent'=>'excon/0.43.0'}).
        to_return(:status => 200, :body => {status:"sent"}.to_json, :headers => {})

      result = client.deliver(mail)
      assert_instance_of Hash, result
      assert_equal "sent", result["status"]
    end

    it "sends the proper API call for multipart text/html e-mails" do
      mail = Mail.new do
        from    "some@sender.tld"
        to      "lucky@receiver.tld"
        subject "Wow, a multipart text and html msg"
        text_part do
          body "This is plain text."
        end
        html_part do
          content_type "text/html; charset=UTF-8"
          body "<html><head></head><body>blaat</body></html>"
        end
      end

      stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
        with(:body => "{\"message\":{\"from_email\":\"some@sender.tld\",\"to\":[{\"email\":\"lucky@receiver.tld\",\"type\":\"to\"}],\"subject\":\"Wow, a multipart text and html msg\",\"text\":\"This is plain text.\",\"html\":\"<html><head></head><body>blaat</body></html>\"},\"async\":false,\"ip_pool\":null,\"send_at\":null,\"key\":\"apikey\"}",
             :headers => {'Content-Type'=>'application/json', 'Host'=>'mandrillapp.com:443', 'User-Agent'=>'excon/0.43.0'}).
        to_return(:status => 200, :body => {status: "sent"}.to_json, :headers => {})

      result = client.deliver(mail)
      assert_instance_of Hash, result
      assert_equal "sent", result["status"]
    end

    it "sends e-mail to multiple recipients" do
      mail = Mail.new do
        from "spam@king.tld"
        to "one@receiver.tld, two@receiver.tld, I am Three <three@receiver.tld>"
        cc "cc-monkey@another-receiver.tld"
        bcc "ghost@hipness.tld, You Can't See Me <invisible@blahblah.tld>"
        subject "you might know who's receiving this"
        text_part do
          body "blah"
        end
        html_part do
          content_type "text/html; charset=UTF-8"
          body "<html><head></head><body>more blah</body></html>"
        end
      end.tap do |mail|
        mail['tag'] = "full_blown_email"
      end

      stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
        with(:body => "{\"message\":{\"from_email\":\"spam@king.tld\",\"to\":[{\"email\":\"one@receiver.tld\",\"type\":\"to\"},{\"email\":\"two@receiver.tld\",\"type\":\"to\"},{\"email\":\"three@receiver.tld\",\"name\":\"I am Three\",\"type\":\"to\"},{\"email\":\"cc-monkey@another-receiver.tld\",\"type\":\"cc\"},{\"email\":\"ghost@hipness.tld\",\"type\":\"bcc\"},{\"email\":\"invisible@blahblah.tld\",\"name\":\"You Can't See Me\",\"type\":\"bcc\"}],\"subject\":\"you might know who's receiving this\",\"tags\":[\"full_blown_email\"],\"text\":\"blah\",\"html\":\"<html><head></head><body>more blah</body></html>\"},\"async\":false,\"ip_pool\":null,\"send_at\":null,\"key\":\"apikey\"}",
             :headers => {'Content-Type'=>'application/json', 'Host'=>'mandrillapp.com:443', 'User-Agent'=>'excon/0.43.0'}).
        to_return(:status => 200, :body => {status:"sent"}.to_json, :headers => {})

      result = client.deliver(mail)
      assert_instance_of Hash, result
      assert_equal "sent", result["status"]
    end

  end

end
