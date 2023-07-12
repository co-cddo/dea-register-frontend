class AgreementsController < ApplicationController
  def index
    agreements = Agreement.all
    agreements = agreements.search(params[:q]) if params[:q].present?
    agreements = agreements.where_first_letter(first_letter) if first_letter

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
