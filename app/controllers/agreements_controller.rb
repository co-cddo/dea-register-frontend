class AgreementsController < ApplicationController
  def index
    agreements = if params[:q].present?
                   Agreement.search(params[:q])
                 else
                   Agreement.all
                 end

    @pagy, @agreements = pagy(agreements)
  end

  def show
    @agreement = Agreement.find(params[:id])
  end
end
