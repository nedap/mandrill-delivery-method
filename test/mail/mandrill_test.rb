require_relative '../test_helper'

describe Mail::Mandrill do

  let(:mandrill) { Mail::Mandrill.new({api_key: 'some-api-key', some_key: 'some-value'}) }
  let(:mail)     { Minitest::Mock.new }
  let(:client)   { Minitest::Mock.new }

  describe "#deliver!" do
    it "invokes deliver on the client" do
      mandrill.instance_variable_set("@client", client)
      client.expect :deliver, "invoked", [mail]
      result = mandrill.deliver!(mail)
      assert_equal result, "invoked"
    end
  end

end
