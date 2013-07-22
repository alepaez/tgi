class Api::V1::ContactController < Api::V1::BaseController

  def create
  end

  def index
    render json: @account.contacts
  end

  def show
  end

  def update
  end

  def destroy
  end
  
end
