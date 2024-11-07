object @agreement
node(:data) do |agreement|
  agreement.fields.except("agreement_name")
end
node(:links) do
  { index: Rails.application.routes.url_helpers.agreements_url(format: :json) }
end
child control_people: :controllers do
  node(:data) do |control_person|
    { name: control_person.name }
  end
end
child powers: :powers do
  node(:data) do |power|
    { name: power.name }
  end
end
child processors: :processors do
  node(:data) do |processor|
    { name: processor.name }
  end
end
