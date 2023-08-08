class AgreementsController < ApplicationController
  before_action :control_people, :applied_filters, :powers, only: :index

  def index
    agreements = control_person ? control_person.agreements : Agreement.all
    agreements = agreements.includes(:powers)

    # Using two queries rather than join as join causes ambiguous column references with fields queries that follow
    agreements = agreements.where(id: [power.agreements.pluck(:id)]) if power

    agreements = agreements.where_first_letter(first_letter) if first_letter
    agreements = agreements.where("fields ->> 'ISA_status' = :status", status: isa_status) if isa_status

    # Using reorder because Agreement has a default scope that sets the order
    # Using unscoped would break the `control_person.agreements` association
    agreements = agreements.reorder(sort_by => direction)

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
      end_date: Arel.sql("(fields ->> 'End_date')::timestamptz"),
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

  def control_people
    @control_people ||= ControlPerson.order(:name).pluck(:name, :id)
  end

  def isa_status
    @isa_status ||= params[:isa_status].presence
  end

  def power
    return if params[:power_filter].blank?

    @power ||= Power.find(params[:power_filter])
  end

  def powers
    @powers ||= Power.order(:name).pluck(:name, :id)
  end

  def applied_filters
    @applied_filters ||= params.to_unsafe_hash.slice(
      :controller_filter, :power_filter, :isa_status, :first_letter, :sort_by, :direction
    ).select { |_k, v| v.present? }
  end
end
