object false
child(@agreements => :agreements) do |_agreement|
  node(:data) do |agreement|
    {
      id: agreement.record_id,
      name: agreement.name,
      isa_status: agreement.fields["isa_status"],
    }
  end
  node(:link) do |agreement|
    Rails.application.routes.url_helpers.agreement_url(agreement, format: :json)
  end
end
node(:links) do
  hash = {
    page_size: @pagy.items,
    current_page: @pagy.page,
  }
  hash[:next] = Rails.application.routes.url_helpers.agreements_url(page: @pagy.next, items: params[:items], format: :json) if @pagy.next
  hash[:previous] = Rails.application.routes.url_helpers.agreements_url(page: @pagy.prev, items: params[:items], format: :json) if @pagy.prev
  hash
end
