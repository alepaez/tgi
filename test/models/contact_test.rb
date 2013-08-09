require "minitest_helper"

class ContactTest < ActiveSupport::TestCase

  subject { Contact.new }

  it { must validate_presence_of(:name) }
  it { must belong_to(:account) }
  it { must have_many(:phones) }
  it { must accept_nested_attributes_for(:phones) }
end
