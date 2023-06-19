# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
Agreement.populate
Power.populate
PowerAgreement.populate

results = {
  agreements: Agreement.count,
  powers: Power.count,
  power_agreements: PowerAgreement.count
}

report = ["The following have been create:"]
results.each {|n,c| report << "\t#{n} - #{c}"}
report = report.join("\n")

Rails.logger.info report
puts report
