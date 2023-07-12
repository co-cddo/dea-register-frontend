# frozen_string_literal: true

module ApplicationHelper
  def sort_button(field, path, label: nil, params: {})
    label ||= field.to_s.humanize
    direction = button_sort_direction(field)
    button_to(
      label,
      path,
      method: :get,
      params: {
        sort_by: field,
        direction:,
      }.merge(params),
    )
  end

  def sort_direction_for(field)
    # Default is to sort by ascending ID
    return :ascending if params[:sort_by].blank? && field == :id

    params[:sort_by] == field.to_s ? params[:direction] : :none
  end

  # Render block within partial if first letter present
  # Otherwise render normally
  def az_content(first_letter, &block)
    content = capture(&block)

    return content unless first_letter

    render "shared/az_content", content:, first_letter:
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
