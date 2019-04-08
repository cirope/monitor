# frozen_string_literal: true

module Scripts::Destroy
  extend ActiveSupport::Concern

  included do
    before_destroy :allow_destruction?
  end

  private

    def allow_destruction?
      if issues.count > 0
				errors.add :base, 'Script can not be destroyed'

				throw :abort
			end
    end
end
