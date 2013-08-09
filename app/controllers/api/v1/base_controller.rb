class Api::V1::BaseController < ActionController::Base

  before_filter :get_token
  before_filter :find_user

  prepend_view_path "app/api_schema"
  respond_to :json, :xml

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def get_token
    @token = params[:api_token] || authenticate_with_http_basic { |token| @token = token }
  end

  def find_user
    @current_user = ApiToken.find_by_token(@token).try(:tokenable)
    return unauthorized unless @current_user
    @account = @current_user.accounts.first
  end

  def unauthorized
    render "api/v1/401", status: :unauthorized
  end

  def not_found
    render "api/v1/404", status: :not_found
  end

  def record_invalid(invalid)
    @errors = invalid.record.errors
    render "api/v1/422", status: :unprocessable_entity
  end

  def nested_attributes_for(model, nested_models)
    return unless params[model]
    nested_models.each do |nested_model|
      next if params[model][nested_model].blank?
      params[model][nested_model + "_attributes"] = params[model][nested_model] 
      params[model].delete(nested_model)
    end
  end

end
