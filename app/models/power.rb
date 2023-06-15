class Power < AirTable
  self.air_table_name = "Power Disclosure"

  has_many :power_agreements
  has_many :agreements, through: :power_agreements
end
