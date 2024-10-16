class Agreement < DataTable
  self.air_table_name = "Information Sharing Agreements"
  self.rapid_table_name = :agreements
  self.rapid_name_field = :agreement_name

  default_scope { order(Arel.sql("(fields ->> 'ID')::Integer")) }

  has_many :power_agreements, dependent: :delete_all
  has_many :powers, through: :power_agreements

  has_many :agreement_control_people, dependent: :delete_all
  has_many :control_people, through: :agreement_control_people

  has_many :agreement_processors, dependent: :delete_all
  has_many :processors, through: :agreement_processors

  def self.isa_statuses
    pluck(Arel.sql("fields -> 'isa_status'")).uniq
  end

  def self.find_by_id!(id)
    find_by!("(fields ->> 'id')::Integer = ?", id.to_i)
  end

  def id_and_name
    [fields["id"], name].select(&:present?).join(" - ")
  end
end
