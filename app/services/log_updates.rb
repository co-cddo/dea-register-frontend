class LogUpdates
  def self.after(time)
    new(time:).update_log
  end

  attr_reader :time

  def initialize(time:)
    @time = time
  end

  def update_log
    return unless changes?

    @update_log ||= UpdateLog.create!(updated_on: time, comment: report)
  end

  def report
    return unless changes?
    return created_text if updated_ids.empty?

    [
      created_text,
      "Additionally, entries with the following ID numbers have been updated:",
      updated_ids.to_sentence,
    ].join(" ")
  end

  def created_text
    [
      number_created,
      "Agreement".pluralize(number_created),
      "created.",
    ].join(" ")
  end

  def changes?
    number_created.positive? || updated_ids.present?
  end

  def number_created
    @number_created ||= Agreement.where(created_at: time..).count
  end

  def updated_ids
    @updated_ids ||= Agreement.where(updated_at: time..)
                              .where.not(created_at: time..)
                              .pluck(Arel.sql("fields->'ID'"))
  end
end
