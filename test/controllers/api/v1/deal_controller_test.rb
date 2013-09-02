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

  describe "Show" do
  end

  describe "Update" do
  end

  describe "Destroy" do
  end
end
