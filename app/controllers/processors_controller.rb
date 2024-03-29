class ProcessorsController < ApplicationController
  # GET /processors
  def index
    processors = Processor.order(:name)
    processors = processors.where_first_letter(first_letter) if first_letter

    @pagy, @processors = pagy(processors)
  end

  # GET /processors/1
  def show
    @processor = Processor.find(params[:id])
  end
end
