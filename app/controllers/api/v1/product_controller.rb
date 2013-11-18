class Api::V1::ProductController < Api::V1::BaseController
  before_filter(only: [ :create, :update ]) do
    prepare_params_for(Product)
  end
  
  def create
    render json: @account.products.create!(params[:product])
  end

  def index
    @result = @account.products
    @result = @result.where("description like ?", "%#{params[:query]}%") unless params[:query].blank?
    @total = @result.count
    @result = @result.page((params[:start].to_i/params[:limit].to_i) + 1).per(params[:limit]) unless params[:start].blank? or params[:limit].blank? or params[:limit].to_i == 0
    @result = @result.order("description ASC")
    render json: { items: JSON.parse(@result.to_json(methods: ['price_localized'])), totalItems: @total }
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
