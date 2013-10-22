#encoding: utf-8
require "minitest_helper"

class Api::V1::DashboardControllerTest < ActionController::TestCase
  before do
    prepare_default_env
  end

  it 'true' do
    assert true
  end

  describe "recent_income" do
    before do
      @product1 = @account.products.create(description: "product1", price_cents: 100)
      @contact1 = @account.contacts.create(name: "contact1", email: "contact1@example.org")

      @deal1 = @contact1.deals.create(items_attributes: [{product_id: @product1.id, quantity:1}], status: "won")
      @deal1.update_attribute(:updated_at, 1.week.ago)
      @deal2 = @contact1.deals.create(items_attributes: [{product_id: @product1.id, quantity:2}], status: "won")
      get :recent_income, api_token: @token
      @response = JSON.parse(response.body)
    end

    it 'response should have last_week' do
      assert @response['last_week'] == "R$1,00"
    end

    it 'response should have this_week' do
      assert @response['this_week'] == "R$2,00"
    end

    it 'response should have growth' do
      assert @response['growth_percent'] == 100
    end
  end
end
