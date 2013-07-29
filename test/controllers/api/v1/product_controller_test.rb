
require "minitest_helper"

class Api::V1::ProductControllerTest < ActionController::TestCase
  before do
    prepare_default_env
    @product = @account.products.create({
      description: "descricao",
      status: "available",
      price_cents: 300
    })
  end

  it 'true' do
    assert true
  end

  describe "Index" do
    before do
      get :index, api_token: @token
      @response = JSON.parse(response.body)
    end

    it 'response should be an Array' do
      assert @response.class == Array
    end

    it 'response should have description' do
      assert @response[0]['description'] == @product.description
    end

    it 'response should have status' do
      assert @response[0]['status'] == @product.status
    end

    it 'response should have price_cents' do
      assert @response[0]['price_cents'] == @product.price_cents
    end
  end

  describe "Show" do
    before do
      get :show, api_token: @token, id: @product.id
      @response = JSON.parse(response.body)
    end

    it 'response should have description' do
      assert @response['description'] == @product.description
    end

    it 'response should have status' do
      assert @response['status'] == @product.status
    end

    it 'response should have price_cents' do
      assert @response['price_cents'] == @product.price_cents
    end
  end

  describe "Create" do
    before do
      post :create, api_token: @token, product: {description: "descricao2", status: "unavailable", price_cents: 150}
      @response = JSON.parse(response.body)
    end

    it 'response should have description' do
      assert @response['description'] == "descricao2"
    end

    it 'response should have status' do
      assert @response['status'] == "unavailable"
    end

    it 'response should have price_cents' do
      assert @response['price_cents'] == 150
    end
  end

  describe "Update" do
    before do
      put :update, api_token: @token, id: @product.id, product: {description: "descricao2", status: "unavailable", price_cents: 150}
      @response = JSON.parse(response.body)
    end

    it 'response should have description' do
      assert @response['description'] == "descricao2"
    end

    it 'response should have status' do
      assert @response['status'] == "unavailable"
    end

    it 'response should have price_cents' do
      assert @response['price_cents'] == 150
    end
  end

  describe "Destroy" do
    before do
      delete :destroy, api_token: @token, id: @product.id
      @response = JSON.parse(response.body)
    end

    it 'response should have description' do
      assert @response['description'] == @product.description
    end

    it 'response should have status' do
      assert @response['status'] == @product.status
    end

    it 'response should have price_cents' do
      assert @response['price_cents'] == @product.price_cents
    end

    it 'should destroy the product' do
      assert_raises(ActiveRecord::RecordNotFound){ Product.find(@product.id) }
    end
  end

end
