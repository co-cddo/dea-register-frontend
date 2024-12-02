class UpdateDataJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Rails.logger.info "Updata Data Job started"
    UpdateDataFromSource.call
    Rails.logger.info "Updata Data Job completed"
  end
end
