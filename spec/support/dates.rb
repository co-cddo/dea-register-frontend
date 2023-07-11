def to_json_date(time)
  time.to_date.to_formatted_s(:db)
end
