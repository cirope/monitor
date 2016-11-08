module Tags::Destroy
  extend ActiveSupport::Concern

  included do
    before_destroy :allow_destruction?
  end

  private

    def allow_destruction?
      if final? && issues.count > 0
				errors.add :base, 'Tag can not be destroyed'

				throw :abort
			end
    end
end
