module Issues::DataType
  extend ActiveSupport::Concern

  included do
    enum data_type: {
      empty:       'empty',
      single_row:  'single_row',
      custom_row:  'custom_row',
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
                       elsif has_custom_row_data?
                         'custom_row'
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

    def has_custom_row_data?
      if options
        key     = data.dig options.dig('custom_row', 'key')
        columns = options.dig 'custom_row', 'columns'

        if key.kind_of?(Hash) && columns.kind_of?(Array)
          (columns - key.keys).blank?
        end
      end
    end
end
