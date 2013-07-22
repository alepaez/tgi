require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/rails"
require "minitest/rails/shoulda"

# Add `gem "minitest-rails-capybara"` to the test group of your Gemfile
# and uncomment the following if you want Capybara feature tests
# require "minitest/rails/capybara"

# Uncomment if you want awesome colorful output
# require "minitest/pride"

Turn.config.format = :dot
Turn.config.natural = true

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  # fixtures :all

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  def prepare_default_env
    @user = User.create(email: "test_user@example.org", password: "tester", password_confirmation: "tester")
    @account = @user.accounts.first
    @token = @user.token.token
  end
end
