class ControlPeopleController < ApplicationController
  def index
    control_people = ControlPerson.all
    control_people = control_people.where_first_letter(first_letter) if first_letter

    @pagy, @control_people = pagy(control_people)
  end

  def show
    @control_person = ControlPerson.find(params[:id])
  end
end
