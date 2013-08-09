class Api::V1::ContactController < Api::V1::BaseController
  before_filter(only: [ :create, :update ]) do
    nested_attributes_for("contact", ["phones"])
  end

  def create
    render json: @account.contacts.create!(params[:contact])
  end

  def index
    render json: @account.contacts
  end

  def show
    render json: @account.contacts.find(params[:id])
  end

  def update
    @contact = @account.contacts.find(params[:id])
    @contact.update_attributes!(params[:contact])
    render json: @contact
  end

  def destroy
    @contact = @account.contacts.find(params[:id])
    @contact.destroy
    render json: @contact
  end
  
end
