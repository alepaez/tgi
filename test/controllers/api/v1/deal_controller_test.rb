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
      status: "open",
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
      post :create, api_token: @token, contact_id: @contact.id.to_param, items: [{quantity: 2, product_id: @product.id.to_param}], status: "open"
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
    describe "all" do
      before do
        get :index, api_token: @token
        @response = JSON.parse(response.body)["items"]
      end

      it 'response should be an Array' do
        assert @response.class == Array
      end

      it 'response should have id' do
        assert @response[0]["id"] == @deal.id.to_param
      end
    end

    describe "search" do
      describe "found" do
        before do
          get :index, api_token: @token, query: "fulano"
          @response = JSON.parse(response.body)["items"]
        end

        it 'response should be an Array' do
          assert @response.class == Array
        end

        it 'response should have id' do
          assert @response[0]["id"] == @deal.id.to_param
        end
      end

      describe "not found" do
        before do
          get :index, api_token: @token, query: "noahd8d1hd10dh18"
          @response = JSON.parse(response.body)["items"]
        end

        it 'response should be an Array' do
          assert @response.class == Array
        end

        it 'response should be empty' do
          assert @response.empty?
        end
      end
    end

    describe "filter" do
      before do
        2.times do
          @deal = @contact.deals.create({
            status: "lost",
            items_attributes: [{ quantity: 1, product_id: @product.id.to_param }]
          })
        end

        3.times do
          @deal = @contact.deals.create({
            status: "won",
            items_attributes: [{ quantity: 1, product_id: @product.id.to_param }]
          })
        end
      end

      it 'response should have facets' do
        get :index, api_token: @token
        @facets = JSON.parse(response.body)["facets"]
        assert @facets["won"]["count"] == 3
        assert @facets["lost"]["count"] == 2
        assert @facets["open"]["count"] == 1
      end

      it 'response should have only won deals' do
        get :index, api_token: @token, status_filter: "won"
        assert JSON.parse(response.body)["items"].count == 3
      end

      it 'response should have only lost deals' do
        get :index, api_token: @token, status_filter: "lost"
        assert JSON.parse(response.body)["items"].count == 2
      end

      it 'response should have only open deals' do
        get :index, api_token: @token, status_filter: "open"
        assert JSON.parse(response.body)["items"].count == 1
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
