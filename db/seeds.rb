# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
Agreement.populate
ControlPerson.populate
Processor.populate
Power.populate
PowerAgreement.populate
PowerControlPerson.populate

results = {
  agreements: Agreement.count,
  control_people: ControlPerson.count,
  processors: Processor.count,
  powers: Power.count,
  power_agreements: PowerAgreement.count,
  power_control_people: PowerControlPerson.count,
}

report = ["The following have been created:"]
results.each { |n, c| report << "\t#{n} - #{c}" }
report = report.join("\n")

# rubocop:disable Rails/Output
puts report # This is sent to STOUT to provide feedback when seeding run at console
Rails.logger.debug report
# rubocop:enable Rails/Output
