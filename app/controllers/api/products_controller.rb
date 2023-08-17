class Api::ProductsController < ApplicationController
  before_action :check_limitation
  
  def index
    render json: { status: "ok"}
  end
end
