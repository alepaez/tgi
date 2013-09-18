class Api::V1::DealController < Api::V1::BaseController
  before_filter(only: [ :create, :update ]) do
    prepare_params_for(Deal, ["items"])
  end

  before_filter :find_scope

  def create
    render json: @scope.create!(params[:deal])
  end

  def index
    render json: @scope.to_json(methods: ['contact_ref'])
  end

  def show
    render json: @scope.find(params[:id])
  end

  def update
    @deal = @scope.find(params[:id])
    @deal = Deal.find(@deal.id)
    @deal.update_attributes!(params[:deal])
    render json: @deal
  end

  def destroy
    @deal = @scope.find(params[:id])
    @deal = Deal.find(@deal.id)
    @deal.destroy
    render json: @deal
  end

  private

  def find_scope
    unless params[:contact_id].blank?
      @scope = @account.contacts.find(params[:contact_id]).deals
    else
      @scope = Deal.joins(:contact).where("contacts.account_id = ?", @account.id)
    end
  end
end
