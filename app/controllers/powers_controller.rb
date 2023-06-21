class PowersController < ApplicationController
  def index
    @pagy, @powers = pagy(Power.includes(:agreements))
  end

  def show
    @power = Power.find(params[:id])
  end
end
