class UpdateLogsController < ApplicationController
  def index
    @update_logs = UpdateLog.order(updated_on: :desc, created_at: :desc)
  end
end
