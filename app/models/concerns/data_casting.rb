# frozen_string_literal: true

module DataCasting
  extend ActiveSupport::Concern

  def converted_data
    recursive_data_convertion data if data
  end

  private

    def recursive_data_convertion object
      object = maybe_convert_to_array_of_hashes object

      if object.kind_of? Hash
        Hash[object.map { |k, v| [k, recursive_data_convertion(v)] }]
      elsif object.kind_of? Array
        object.map { |v| recursive_data_convertion(v) }
      else
        object
      end
    end

    def maybe_convert_to_array_of_hashes object
      is_array           = object.kind_of? Array
      is_two_dimensional = is_array && object.all? { |item| item.is_a? Array }
      uniq_item_sizes    = is_two_dimensional && object.map(&:size).uniq

      if is_two_dimensional && uniq_item_sizes.size == 1
        headers = object.shift

        object.map { |row| Hash[headers.zip row] }
      else
        object
      end
    end
end
