# frozen_string_literal: true

class Serie < ApplicationRecord
  establish_connection :metrics

  include Series::Validations
  include Series::Tentant

  def self.add rows = []
    rows.each { |r| increment r }
  end

  def self.increment attributes = {}
    name       = extract_translated_attr_from :name, attributes
    identifier = extract_translated_attr_from :identifier, attributes
    amount     = extract_translated_attr_from :amount, attributes
    date       = Time.at(attributes.delete :ts)

    s = find_or_initialize_by(
      name:       name,
      date:       date,
      identifier: identifier
    )

    s.count  = s.count.to_i + 1
    s.amount = s.amount.to_f + amount
    s.data   = Hash(s.data).merge attributes

    s.save!
  end

  def self.extract_translated_attr_from attr, attributes
    attributes.delete(human_attribute_name(attr).downcase.to_sym) ||
      attributes.delete(attr)
  end
end
