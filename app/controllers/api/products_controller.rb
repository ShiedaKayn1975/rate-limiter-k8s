class Api::ProductsController < ApplicationController
  before_action :check_limitation_ip_address

  def index
    render json: { status: 'ok' }
  end
end
