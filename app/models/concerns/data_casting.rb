# frozen_string_literal: true

module DataCasting
  extend ActiveSupport::Concern

  def converted_data
    if data
      case data_type
      when 'single_row'  then recursive_data_convertion data
      when 'display_row' then display_row_data_convertion data.with_indifferent_access
      end
    end
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
        dup     = object.dup
        headers = dup.shift

        dup.map { |row| Hash[headers.zip row] }
      else
        object
      end
    end

    def display_row_data_convertion object
      opts            = options.with_indifferent_access
      display_row     = object.dig opts.dig(:display_row)
      display_columns = opts.dig :display_columns

      display_row.slice *display_columns
    end
end
