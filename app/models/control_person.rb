class ControlPerson < DataTable
  self.air_table_name = "Controllers"
  self.rapid_table_name = :controllers
  self.rapid_name_field = :controller_name

  has_many :power_control_people, dependent: :delete_all
  has_many :powers, through: :power_control_people

  has_many :agreement_control_people, dependent: :delete_all
  has_many :agreements, through: :agreement_control_people
end
