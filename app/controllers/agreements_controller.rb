class AgreementsController < ApplicationController
  def index
    @agreements = Agreement.all
  end

  def show
    @agreement = Agreement.find(params[:id])
  end
end
