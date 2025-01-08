class ControlPerson < DataTable
  self.rapid_table_name = :controllers
  self.rapid_name_field = :controller_name

  has_many :agreement_control_people, dependent: :delete_all
  has_many :agreements, through: :agreement_control_people
end
