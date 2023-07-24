class PowersController < ApplicationController
  def index
    powers = Power.includes(:agreements).order(:name)
    powers = powers.where_first_letter(first_letter) if first_letter

    @pagy, @powers = pagy(powers)
  end

  def show
    @power = Power.find(params[:id])
  end
end
