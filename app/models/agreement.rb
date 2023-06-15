class Agreement < AirTable
  self.air_table_name = "Information Sharing Agreements"

  has_many :power_agreements
  has_many :powers, through: :power_agreements
end
