module Scripts::ModeContainer
  extend ActiveSupport::Concern

  def container_commented_text comment = nil
    comment ||= 'script container'
  end
end
