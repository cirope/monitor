# frozen_string_literal: true

module DatabasesHelper
  def properties
    @database.properties.new if @database.properties.empty?

    @database.properties
  end

  def value_of property
    if property.password?
      '*' * property.value.length
    else
      property.value
    end
  end
end
