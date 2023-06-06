class AgreementsController < ApplicationController
  def index
    @pagy, @agreements = pagy(Agreement.all)
  end

  def show
    @agreement = Agreement.find(params[:id])
  end
end
