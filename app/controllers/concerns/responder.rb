require 'application_responder'

module Responder
  extend ActiveSupport::Concern

  included do
    self.responder = ApplicationResponder
  end
end
