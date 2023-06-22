# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
results = [
  Agreement,
  ControlPerson,
  Processor,
  Power,
  PowerAgreement,
  PowerControlPerson,
  AgreementControlPerson,
  AgreementProcessor,
].each_with_object({}) do |model, hash|
  model.populate
  hash[model.to_s] = model.count
end

report = ["The following have been created:"]
results.each { |n, c| report << "\t#{n} - #{c}" }
report = report.join("\n")

# rubocop:disable Rails/Output
puts report # This is sent to STOUT to provide feedback when seeding run at console
Rails.logger.debug report
# rubocop:enable Rails/Output
