class Power < DataTable
  self.air_table_name = "Power Disclosure"

  has_many :power_agreements
  has_many :agreements, through: :power_agreements

  has_many :power_control_people
  has_many :control_people, through: :power_control_people
end
