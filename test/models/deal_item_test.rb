require "minitest_helper"

class DealItemTest < ActiveSupport::TestCase

  subject { DealItem.new }

  it { must belong_to :deal }
  it { must belong_to :product }
  it { must validate_presence_of :quantity }
  
end
