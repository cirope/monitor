module Users::Origin
  extend ActiveSupport::Concern

  included do
    before_validation :set_origin
  end

  def manual?
    Hash(data).fetch('origin', 'manual') == 'manual'
  end

  private

    def set_origin
      self.data           ||= {}
      self.data['origin'] ||= 'manual'
    end
end
