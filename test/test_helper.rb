require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
CodeClimate::TestReporter.configuration.git_dir = "."

require_relative '../lib/mandrill-delivery-method'
require 'rails/all'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'
require 'webmock'
require 'webmock/minitest'

WebMock.disable_net_connect! allow: 'codeclimate.com'
