module Issues::DataType
  extend ActiveSupport::Concern

  included do
    enum data_type: {
      empty:       'empty',
      single_row:  'single_row',
      display_row: 'display_row',
      object:      'object'
    }, _suffix: true

    after_validation :set_data_type, if: :set_data_type?
  end

  private

    def set_data_type?
      data_changed? || new_record? || data_type.blank? || options_changed?
    end

    def set_data_type
      self.data_type = if data.blank?
                         'empty'
                       elsif has_single_row_data?
                         'single_row'
                       elsif has_display_row_data?
                         'display_row'
                       else
                         'object'
                       end
    end

    def has_single_row_data?
      data = converted_data

      data.kind_of?(Array) && (
        data.size == 1 && data.first.kind_of?(Hash)
      )
    end

    def has_display_row_data?
      if opts = options&.with_indifferent_access
        display_row     = data.dig opts.dig(:display_row)
        display_columns = opts.dig :display_columns

        if display_row.kind_of?(Hash) && display_columns.kind_of?(Array)
          (display_columns - display_row.keys).blank?
        end
      end
    end
end
