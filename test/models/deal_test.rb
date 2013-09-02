require "minitest_helper"

class DealTest < ActiveSupport::TestCase
  subject { Deal.new }

  it { must belong_to :contact }
  it { must have_many :items }
  it { must accept_nested_attributes_for(:items) }
  
end
