class Processor < AirTable
  self.air_table_name = "Processors"

  has_many :agreement_processors
  has_many :agreements, through: :agreement_processors
end
