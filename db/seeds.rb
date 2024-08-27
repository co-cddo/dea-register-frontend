# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

# rubocop:disable Rails/Output
starting = "Seeding data from #{Rails.configuration.data_source}"
puts starting # This is sent to STOUT to provide feedback when seeding run at console
Rails.logger.debug starting


start_time = Time.zone.now

# Clear the search cache
PgSearch::Document.delete_all

models = [
  Agreement,
  ControlPerson,
  Processor,
  Power,
  PowerAgreement,
  PowerControlPerson,
  AgreementControlPerson,
  AgreementProcessor,
]

models.each(&:populate)

models.each do |model|
  PgSearch::Multisearch.rebuild(model, clean_up: false) if model.respond_to?(:multisearchable)
end

# Load historic update logs from previous system
update_records = YAML.load_file(
  Rails.root.join("db/seeds/update_record.yml"),
  symbolize_names: true,
)

update_records.each do |record|
  date = Date.parse(record[:date])
  UpdateLog.where(from_seeds: true).find_or_create_by!(updated_on: date) do |update_log|
    update_log.comment = record[:text]
    update_log.from_seeds = true
  end
end

report = LogUpdates.after(start_time)&.comment || "No changes made on seeding"

puts report # This is sent to STOUT to provide feedback when seeding run at console
Rails.logger.debug report
# rubocop:enable Rails/Output
