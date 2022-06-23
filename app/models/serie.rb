# frozen_string_literal: true

class Serie < ApplicationRecord
  include Series::Validations

  def self.add rows = []
    rows.map { |r| create_sample r.symbolize_keys }.all?
  end

  def self.create_sample attributes = {}
    name       = extract_translated_attr_from :name, attributes
    identifier = extract_translated_attr_from :identifier, attributes
    amount     = extract_translated_attr_from :amount, attributes
    timestamp  = attributes.delete :timestamp

    serie = new(
      name:       name,
      identifier: identifier,
      amount:     amount,
      timestamp:  timestamp,
      data:       attributes
    )

    serie.save
  end

  def self.extract_translated_attr_from attr, attributes
    attributes.delete(human_attribute_name(attr).downcase.to_sym) ||
      attributes.delete(attr)
  end

  def to_s
    name
  end
end
