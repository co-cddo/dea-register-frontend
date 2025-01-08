class UpdateDataFromSource
  def self.call
    # Clear the search cache
    PgSearch::Document.delete_all

    models = [
      Agreement,
      ControlPerson,
      Processor,
      Power,
      PowerAgreement,
      AgreementControlPerson,
      AgreementProcessor,
    ]

    models.each(&:populate)

    # Rebuild the search database
    # ---------------------------
    # Rebuilding for each class would normally do this, but the single table inheritance causes a problem
    # because the search record identifies each item by the table name which is always "data_tables".
    # This means that as you rebuild each class, the process will first remove the search records
    # for the classes that have previously been built.
    # To fix this first all the DataTable data is cleared, and then each class is rebuilt without
    # cleanup.
    PgSearch::Document.delete_by(searchable_type: "DataTable")

    models.each do |model|
      PgSearch::Multisearch.rebuild(model, clean_up: false) if model.respond_to?(:multisearchable)
    end
  end
end
