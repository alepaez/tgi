require "minitest_helper"

class PhoneTest < ActiveSupport::TestCase

  subject { Phone.new }

  it { must belong_to(:contact) }
  it { must validate_presence_of(:number) }

end
