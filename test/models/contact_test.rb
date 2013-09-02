require "minitest_helper"

class ContactTest < ActiveSupport::TestCase

  subject { Contact.new }

  it { must validate_presence_of(:name) }
  it { must belong_to(:account) }
  it { must have_many(:phones) }
  it { must have_many(:addresses) }
  it { must have_many(:deals) }
  it { must accept_nested_attributes_for(:phones) }
  it { must accept_nested_attributes_for(:addresses) }
end
