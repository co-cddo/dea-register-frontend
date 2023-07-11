class AgreementsController < ApplicationController
  def index
    agreements = if params[:q].present?
                   Agreement.search(params[:q])
                 else
                   Agreement.all
                 end

    agreements = agreements.order(sort_by => direction)

    @pagy, @agreements = pagy(agreements)
  end

  def show
    @agreement = Agreement.find(params[:id])
  end

private

  def sort_by
    options = {
      name: :name,
      id: Arel.sql("(fields ->> 'ID')::Integer"),
      start_date: Arel.sql("(fields ->> 'Start_date')::timestamptz"),
    }

    return options[:id] if params[:sort_by].blank?

    options.fetch(params[:sort_by].to_sym, options[:id])
  end

  def direction
    return :asc if params[:sort_by].blank?

    params[:direction] == "descending" ? :desc : :asc
  end
end
