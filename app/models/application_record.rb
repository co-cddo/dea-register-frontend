# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.air_table_data_source?
    Rails.configuration.data_source == :airtable
  end
end
