class Api::V1::DealController < Api::V1::BaseController
  before_filter(only: [ :create, :update ]) do
    prepare_params_for(Deal, ["items"])
  end

  before_filter :find_contact

  def create
    render json: @contact.deals.create!(params[:deal])
  end

  def index
    render json: @contact.deals
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def find_contact
    @contact = @account.contacts.find(params[:contact_id])
  end
end
