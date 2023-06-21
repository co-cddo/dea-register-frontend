class ProcessorsController < ApplicationController
  # GET /processors
  def index
    @pagy, @processors = pagy(Processor.all)
  end

  # GET /processors/1
  def show
    @processor = Processor.find(params[:id])
  end
end
