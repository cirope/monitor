module Scripts::Status
  extend ActiveSupport::Concern

  def has_errors?
    status && status['errors']
  end

  def has_warnings?
    status && status['warnings']
  end

  def update_status errors, warnings
    new_status = { errors: errors, warnings: warnings }

    update_column :status, new_status
  end
end
