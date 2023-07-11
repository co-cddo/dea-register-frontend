# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

private

  def first_letter
    @first_letter ||= params[:first_letter].presence
  end
end
