module Issues::DataType
  extend ActiveSupport::Concern

  included do
    enum data_type: {
      empty:      'empty',
      single_row: 'single_row',
      object:     'object'
    }, _suffix: true

    after_validation :set_data_type, if: :set_data_type?
  end

  private

    def set_data_type?
      data_changed? || new_record? || data_type.blank?
    end

    def set_data_type
      self.data_type = if data.blank?
                         'empty'
                       elsif has_single_row_data?
                         'single_row'
                       else
                         'object'
                       end
    end

    def has_single_row_data?
      data.kind_of?(Array) && (
        (
          data.size == 1 &&
          data.first.kind_of?(Hash)
        ) || (
          data.size == 2                      &&
          data.all? { |i| i.kind_of?(Array) } &&
          data.map(&:size).uniq.size == 1
        )
      )
    end
end
