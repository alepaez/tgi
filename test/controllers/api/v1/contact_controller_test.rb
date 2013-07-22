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

  describe "Create" do
    before do
      post :create, api_token: @token, contact: {name: "Contato Importante", email: "contato_importante@example.org"}
      @response = JSON.parse(response.body)
    end

    it 'response should have name' do
      assert @response['name'] == "Contato Importante"
    end

    it 'response should have email' do
      assert @response['email'] == "contato_importante@example.org"
    end
  end

  describe "Show" do
    before do
      get :show, api_token: @token, id: @contact.id.to_param
      @response = JSON.parse(response.body)
    end

    it 'response should have name' do
      assert @response['name'] == @contact.name
    end

    it 'response should have email' do
      assert @response['email'] == @contact.email
    end

    it 'response should have id' do
      assert @response['id'] == @contact.id.to_param
    end
  end

  describe "Update" do
    before do
      put :update, api_token: @token, contact: {name: "Contato Importante", email: "contato_importante@example.org"}, id: @contact.id.to_param
      @response = JSON.parse(response.body)
    end

    it 'response should have name' do
      assert @response['name'] == "Contato Importante"
    end

    it 'response should have email' do
      assert @response['email'] == "contato_importante@example.org"
    end

    it 'response should have id' do
      assert @response['id'] == @contact.id.to_param
    end
  end

  describe "Destroy" do
    before do
      delete :destroy, api_token: @token, id: @contact.id.to_param
      @response = JSON.parse(response.body)
    end

    it 'response should have name' do
      assert @response['name'] == @contact.name
    end

    it 'response should have email' do
      assert @response['email'] == @contact.email
    end

    it 'response should have id' do
      assert @response['id'] == @contact.id.to_param
    end

    it 'should destroy contact' do
      assert_raises(ActiveRecord::RecordNotFound){ Contact.find(@contact.id) }
    end
  end

end
