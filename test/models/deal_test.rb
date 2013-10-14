require "minitest_helper"

class DealTest < ActiveSupport::TestCase
  subject { Deal.new }

  it { must belong_to :contact }
  it { must have_many :items }
  it { must accept_nested_attributes_for(:items) }

  describe "total methods" do
    before do
      prepare_default_env
      @contact = @account.contacts.create({
        name: "Fulano de Tal",
        email: "tester@example.org"
      })

      @product = @account.products.create({
        description: "produto",
        price_cents: 100
      })

      @deal = @contact.deals.create({
        status: "open",
        items_attributes: [
          {
            quantity: 2,
            product_id: @product.id.to_param
          }
        ]
      })
    end

    it 'should return total items cents' do
      assert @deal.total_cents == 200
    end

    it 'should return localized total items value' do
      assert @deal.total_localized == "R$ 2,00"
    end
  end
  
end
