require "minitest_helper"

class Api::V1::ContactControllerTest < ActionController::TestCase
  before do
    prepare_default_env
    @contact = @account.contacts.create({
      name: "Fulano de Tal",
      email: "tester@example.org"
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

    it 'response should have name' do
      assert @response[0]['name'] == @contact.name
    end

    it 'response should have email' do
      assert @response[0]['email'] == @contact.email
    end

    it 'response should have id' do
      assert @response[0]['id'] == @contact.id.to_param
    end
  end

end
