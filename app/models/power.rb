class Power < DataTable
  self.rapid_table_name = :dea_upload_powers
  self.rapid_name_field = :name

  has_many :power_agreements
  has_many :agreements, through: :power_agreements
end
