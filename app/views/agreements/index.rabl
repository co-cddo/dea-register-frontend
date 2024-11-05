object false
child(@agreements => :agreements) do |agreement|
  node(:data) do |agreement|
    {
      id: agreement.record_id,
      name: agreement.name
    }
  end
  node(:link) do |agreement|
    Rails.application.routes.url_helpers.agreement_url(agreement, format: :json)
  end
end
node(:links) do
  hash = {
    page_size: @pagy.items,
    current_page: @pagy.page
  }
  hash[:next] = Rails.application.routes.url_helpers.agreements_url(page: @pagy.next, format: :json) if @pagy.next
  hash[:previous] = Rails.application.routes.url_helpers.agreements_url(page: @pagy.prev, format: :json) if @pagy.prev
  hash
end

# collection @agreements => :agreements
# node(:data) do |agreement|
#   { name: agreement.name }
# end
# node(:link) do |agreement|
#   Rails.application.routes.url_helpers.agreement_url(agreement, format: :json)
# end

