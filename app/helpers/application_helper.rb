# frozen_string_literal: true

module ApplicationHelper
  def page_title(site_name:, additional: nil, preferred: nil)
    detail = preferred.presence || additional

    [site_name, detail].select(&:present?).join(" - ")
  end

  def non_breaking_date(text)
    return text if text.blank?

    text.gsub("-", "&#8209;").html_safe
  end

  def sort_button(field, path, label: nil, params: {})
    label ||= field.to_s.humanize
    direction = button_sort_direction(field)
    button_to(
      label,
      path,
      method: :get,
      params: params.merge(
        sort_by: field,
        direction:,
      ),
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

  def latest_update
    @latest_update ||= UpdateLog.order(:updated_at).last
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
