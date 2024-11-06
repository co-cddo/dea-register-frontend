class SourceRecordCleaner
  def self.clean(record)
    new(record).clean
  end

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def clean
    remove_invalid_dates(:start_date, :end_date, :review_date)
    record
  end

  def remove_invalid_dates(*fields)
    fields.each do |field|
      record[field] = nil unless valid_date?(record[field])
    end
  end

  def valid_date?(date)
    Time.zone.parse(date)
  rescue ArgumentError, TypeError
    false
  end
end
