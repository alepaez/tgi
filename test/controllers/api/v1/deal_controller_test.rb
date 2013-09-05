#encoding: utf-8
require "minitest_helper"

class Api::V1::DealControllerTest < ActionController::TestCase
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
      items_attributes: [
        {
          quantity: 1,
          product_id: @product.id.to_param
        }
      ]
    })
  end

  it 'true' do
    assert true
  end

  describe "Create" do
    before do
      post :create, api_token: @token, contact_id: @contact.id.to_param, items: [{quantity: 2, product_id: @product.id.to_param}]
      @response = JSON.parse(response.body)
    end

    it 'response should have items' do
      assert @response["items"].class == Array
    end

    it 'response should have items quantities' do
      assert @response["items"][0]["quantity"] == 2
    end
  end

  describe "Index" do
    describe "without contact_id" do
      before do
        get :index, api_token: @token
        @response = JSON.parse(response.body)
      end

      it 'response should be an Array' do
        assert @response.class == Array
      end

      it 'response should have id' do
        assert @response[0]["id"] == @deal.id.to_param
      end
    end

    describe "with contact_id" do
      before do
        get :index, api_token: @token, contact_id: @contact.id.to_param
        @response = JSON.parse(response.body)
      end

      it 'response should be an Array' do
        assert @response.class == Array
      end

      it 'response should have id' do
        assert @response[0]["id"] == @deal.id.to_param
      end
    end
  end

  describe "Show" do
    before do
      get :show, api_token: @token, contact_id: @contact.id.to_param, id: @deal.id.to_param
      @response = JSON.parse(response.body)
    end

    it 'response should have id' do
      assert @response["id"] == @deal.id.to_param
    end

    it 'response should have items' do
      assert @response["items"].class == Array
    end

    it 'response should have items quantities' do
      assert @response["items"][0]["quantity"] == @deal.items.first.quantity
    end
  end

  describe "Update" do
    before do
      put :update, api_token: @token, contact_id: @contact.id.to_param, id: @deal.id.to_param, items: [{quantity: 4, id: @deal.items.first.id.to_param}]
      @response = JSON.parse(response.body)
    end

    it 'response should have id' do
      assert @response["id"] == @deal.id.to_param
    end

    it 'response should have items' do
      assert @response["items"].class == Array
    end

    it 'response should have items quantities' do
      assert @response["items"][0]["quantity"] == 4
    end
  end

  describe "Destroy" do
    before do
      @item = @deal.items.first
      delete :destroy, api_token: @token, contact_id: @contact.id.to_param, id: @deal.id.to_param
      @response = JSON.parse(response.body)
    end

    it 'response should have id' do
      assert @response["id"] == @deal.id.to_param
    end

    it 'should destroy deal' do
      assert_raises(ActiveRecord::RecordNotFound){ Deal.find(@deal.id) }
    end

    it 'should destroy deal_items' do
      assert_raises(ActiveRecord::RecordNotFound){ DealItem.find(@item.id) }
    end
  end
end
