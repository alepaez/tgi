class ApplicationController < ActionController::Base
  protect_from_forgery

  layout false

  before_filter :authenticate_user!, only: [ :app ]

  def index
  end

  def app
    @current_user = current_user
  end
end
