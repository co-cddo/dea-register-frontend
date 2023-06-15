class PowersController < ApplicationController
  def index
    @powers = Power.includes(:agreements)
  end

  def show
    @power = Power.find(params[:id])
  end
end
