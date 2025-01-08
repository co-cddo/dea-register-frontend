class Agreement < DataTable
  self.rapid_table_name = :agreements
  self.rapid_name_field = :agreement_name

  default_scope { order(Arel.sql("CAST(record_id AS Integer)")) }

  has_many :power_agreements, dependent: :delete_all
  has_many :powers, through: :power_agreements

  has_many :agreement_control_people, dependent: :delete_all
  has_many :control_people, through: :agreement_control_people

  has_many :agreement_processors, dependent: :delete_all
  has_many :processors, through: :agreement_processors

  class << self
    def isa_statuses
      pluck(Arel.sql("fields -> 'isa_status'")).uniq
    end

    def find_by_id!(id)
      find_by!("(fields ->> 'id')::Integer = ?", id.to_i)
    end

    def before_populate_save(instance)
      end_date = instance.fields["end_date"].presence
      status = end_date && (Time.zone.parse(end_date) < Time.zone.now) ? "Complete" : "Active"
      instance.fields["isa_status"] = status
    end
  end

  def id_and_name
    [fields["id"], name].select(&:present?).join(" - ")
  end

  def to_param
    record_id
  end
end
