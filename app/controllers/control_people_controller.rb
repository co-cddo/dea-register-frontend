class ControlPeopleController < ApplicationController

  def index
    @control_people = ControlPerson.all
  end

  def show
    @control_person = ControlPerson.find(params[:id])
  end
end
