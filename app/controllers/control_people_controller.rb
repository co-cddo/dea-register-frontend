class ControlPeopleController < ApplicationController
  def index
    @pagy, @control_people = pagy(ControlPerson.all)
  end

  def show
    @control_person = ControlPerson.find(params[:id])
  end
end
