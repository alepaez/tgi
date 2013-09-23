class Api::V1::ProductController < Api::V1::BaseController
  before_filter(only: [ :create, :update ]) do
    prepare_params_for(Product)
  end
  
  def create
    render json: @account.products.create!(params[:product])
  end

  def index
    @response = @account.products
    @response = @response.where("description like ?", "%#{params[:query]}%") unless params[:query].blank?
    render json: @response
  end

  def show
    render json: @account.products.find(params[:id])
  end

  def update
    @product = @account.products.find(params[:id])
    @product.update_attributes!(params[:product])
    render json: @product
  end

  def destroy
    @product = @account.products.find(params[:id])
    @product.destroy
    render json: @product
  end
end
