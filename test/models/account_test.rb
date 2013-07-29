require "minitest_helper"

class AccountTest < ActiveSupport::TestCase

  subject { Account.new }

  it { must have_many(:contacts) }
  it { must have_many(:products) }
  
end
