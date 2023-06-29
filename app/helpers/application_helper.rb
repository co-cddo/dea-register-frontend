# frozen_string_literal: true

module ApplicationHelper
  def sort_button(field, path, label: nil)
    label ||= field.to_s.humanize
    direction = button_sort_direction(field)
    button_to(
      label,
      path,
      method: :get,
      params: {
        sort_by: field,
        direction:,
      },
    )
  end

  def sort_direction_for(field)
    # Default is to sort by ascending ID
    return :ascending if params[:sort_by].blank? && field == :id

    params[:sort_by] == field.to_s ? params[:direction] : :none
  end

private

  def button_sort_direction(field)
    # Default is to sort by ascending ID
    # So if no sorting is set, the next direction for the id button is descending
    return :descending if params[:sort_by].blank? && field == :id

    # Otherwise set next action as ascending unless the current sort for this field is already ascending
    params[:direction] == "ascending" && params[:sort_by] == field.to_s ? :descending : :ascending
  end
end
