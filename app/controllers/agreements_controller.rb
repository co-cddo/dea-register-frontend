class AgreementsController < ApplicationController
  before_action :control_people, :applied_filters, only: :index

  def index
    agreements = control_person ? control_person.agreements : Agreement.all
    agreements = agreements.where_first_letter(first_letter) if first_letter
    agreements = agreements.where("fields ->> 'ISA_status' = :status", status: isa_status) if isa_status

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

  def control_person
    return if params[:controller_filter].blank?

    @control_person ||= ControlPerson.find(params[:controller_filter])
  end

  def isa_status
    @isa_status ||= params[:isa_status].presence
  end

  def control_people
    @control_people ||= ControlPerson.order(:name).pluck(:name, :id)
  end

  def applied_filters
    @applied_filters ||= params.to_unsafe_hash.slice(
      :controller_filter, :isa_status, :first_letter, :sort_by, :direction
    ).select { |_k, v| v.present? }
  end
end
