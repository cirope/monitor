# frozen_string_literal: true

class DatePickerInput < SimpleForm::Inputs::Base
  def input wrapper_options
    combined_input_html_options = merge_wrapper_options input_html_options, wrapper_options

    @builder.text_field(
      attribute_name, {
        data:         default_data_options,
        value:        value,
        autocomplete: 'off'
      }.deep_merge(combined_input_html_options)
    ).html_safe
  end

  def input_html_classes
    super << 'form-control'
  end

  private

    def value
      if object.respond_to?(attribute_name) && object.send(attribute_name)
        I18n.l(object.send(attribute_name), format: :compact)
      end
    end

    def default_data_options
      {
        date_picker:        true,
        date_time:          true,
        date_locale_apply:  I18n.t('datepicker.apply'),
        date_locale_cancel: I18n.t('datepicker.cancel')
      }
    end
end
