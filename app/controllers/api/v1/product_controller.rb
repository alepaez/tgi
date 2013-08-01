class Api::V1::ProductController < Api::V1::BaseController
  
  def create
    render json: @account.products.create!(params[:product])
  end

  def index
    render json: @account.products
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