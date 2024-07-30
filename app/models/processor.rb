class Processor < DataTable
  self.air_table_name = "Processors"
  self.rapid_table_name = :processors

  has_many :agreement_processors, dependent: :delete_all
  has_many :agreements, through: :agreement_processors
end
