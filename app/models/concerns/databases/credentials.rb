# frozen_string_literal: true

module Databases::Credentials
  extend ActiveSupport::Concern

  def user
    property = properties.detect { |p| p.key =~ /\Auser/i }

    property&.value
  end

  def password
    property = properties.detect { |p| p.key =~ /\Apass/i }

    property&.value
  end
end
