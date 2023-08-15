module Scripts::Cleanup
  extend ActiveSupport::Concern

  def cleanup
    executions.map &:destroy
  end
end
