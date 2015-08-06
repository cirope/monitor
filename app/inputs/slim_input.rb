class SlimInput < SimpleForm::Inputs::Base
  def input wrapper_options
    @builder.text_field attribute_name, input_options(wrapper_options)
  end

  def label wrapper_options
    false
  end

  def input_html_classes
    super << 'form-control'
  end

  private

    def input_options wrapper_options
      {
        placeholder: raw_label_text,
        title: raw_label_text,
      }.deep_merge merge_wrapper_options(input_html_options, wrapper_options)
    end
end
