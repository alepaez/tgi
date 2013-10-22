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

  describe "validate_changes" do
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

    it 'should not be modified if its already won' do
      @deal.update_attributes(status: "won")
      @deal.status = "open"
      assert !@deal.valid?
    end

    it 'should not be modified if its already lost' do
      @deal.update_attributes(status: "lost")
      @deal.status = "open"
      assert !@deal.valid?
    end
  end
  
end
