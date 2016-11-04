$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'ebay_finding_api'
require 'rspec'
require 'webmock/rspec'
require 'vcr'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |c|
  c.configure_rspec_metadata!

  c.filter_sensitive_data("<EBAY_APP_ID>") do
    ENV['EBAY_APP_ID']
  end

  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
end

# The app id to use during testing.
#
# @return The host name.
def ebay_app_id
  ENV.fetch 'EBAY_APP_ID'
end
