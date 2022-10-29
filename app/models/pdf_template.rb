# frozen_string_literal: true

class PdfTemplate < ApplicationRecord
  include Attributes::Strip
  include PdfTemplates::Validation

  strip_fields :name
  has_rich_text :content
end
