module Comments::Destroy
  extend ActiveSupport::Concern

  included do
    after_destroy :destroy_attachment
  end

  private

    def destroy_attachment
      attachment.purge if attachment.attached?
    end
end
