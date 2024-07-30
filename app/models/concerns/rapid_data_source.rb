module RapidDataSource
  def populate_from_rapid
    data = RapidApi.new.output_for(rapid_table_name)
    created_ids = []

    data.values.each do |record|

      instance = find_or_initialize_by(record_id: record[:id])

      name = record[rapid_name_field]

      # If name divided in two by a colon only use the last part in the instance name
      name = name.split(":").last if name&.count(":") == 1
      instance.name = name.strip

      instance.fields = record
      instance.save!
      created_ids << instance.id
    end

    # Remove records that no longer match any on rAPId (assume deleted)
    where.not(id: created_ids).destroy_all
  end
end

