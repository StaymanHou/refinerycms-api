module Refinery
  module Api
    include ActiveSupport::Configurable

    config_accessor :requires_authentication
    config_accessor :auth_token

    self.requires_authentication = true
    self.auth_token = ENV['REFINERY_API_AUTH_TOKEN']
  end
end