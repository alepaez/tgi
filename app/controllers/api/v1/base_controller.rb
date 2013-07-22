class Api::V1::BaseController < ActionController::Base

  before_filter :find_user

  prepend_view_path "app/api_schema"
  respond_to :json, :xml

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def find_user
    @current_user = ApiToken.find_by_token(params[:api_token]).try(:tokenable)
    return unauthorized unless @current_user
    @account = @current_user.accounts.first
  end

  def unauthorized
    render "api/v1/401", status: :unauthorized
  end

  def not_found
    render "api/v1/404", status: :not_found
  end

  def record_invalid
    render "api/v1/422", status: :unprocessable_entity
  end

end
