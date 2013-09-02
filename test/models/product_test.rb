require "minitest_helper"

class ProductTest < ActiveSupport::TestCase
  subject { Product.new }

  it { must belong_to(:account) }
  it { must validate_presence_of(:description) }
  it { must validate_presence_of(:price_cents) }
end
