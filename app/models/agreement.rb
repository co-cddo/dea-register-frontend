class Agreement < AirTable
  self.air_table_name = "Information Sharing Agreements"

  default_scope { order(Arel.sql("(fields ->> 'ID')::Integer")) }

  has_many :power_agreements, dependent: :delete_all
  has_many :powers, through: :power_agreements

  has_many :agreement_control_people, dependent: :delete_all
  has_many :control_people, through: :agreement_control_people

  has_many :agreement_processors, dependent: :delete_all
  has_many :processors, through: :agreement_processors

  def self.isa_statuses
    pluck(Arel.sql("fields -> 'ISA_status'")).uniq
  end

  def id_and_name
    [fields["ID"], name].select(&:present?).join(" - ")
  end
end
