class Api::ProductsController < ApplicationController
  before_action :check_limitation

  def index
    binding.pry
    render json: { status: "ok"}
  end
end
