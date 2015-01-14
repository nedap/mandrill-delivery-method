require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require_relative '../lib/mandrill-delivery-method'
require 'rails/all'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'
require 'webmock'
require 'webmock/minitest'

WebMock.disable_net_connect!
