class MetadataController < ApplicationController
  def show
    render params[:id]
  end
end
