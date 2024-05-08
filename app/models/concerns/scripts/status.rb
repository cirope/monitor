module Scripts::Status
  extend ActiveSupport::Concern

  def status_errors?
    status && status['errors']
  end

  def status_warnings?
    status && status['warnings']
  end

  def update_status errors, warnings
    new_status = { errors: errors, warnings: warnings }

    update_column :status, new_status
  end
end
