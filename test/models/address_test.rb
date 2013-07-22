require "minitest_helper"

class AddressTest < ActiveSupport::TestCase

  subject { Address.new }

  it { must validate_presence_of(:country) }
  it { must validate_presence_of(:state) }
  it { must validate_presence_of(:address) }
  it { must validate_presence_of(:number) }
  it { must belong_to(:contact) }
  
end
