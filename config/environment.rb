# Load the Rails application.
require File.expand_path('../application', __FILE__)
require 'trello'

# Initialize the Rails application.
TrelloScheduleDashboard::Application.initialize!

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  # https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=My+Application&expiration=never&response_type=token
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end
