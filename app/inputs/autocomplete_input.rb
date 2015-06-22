class AutocompleteInput < SimpleForm::Inputs::Base
  def input wrapper_options
    autocomplete_field(wrapper_options) << hidden_field
  end

  def input_html_classes
    super << 'form-control'
  end

  private

    def autocomplete_field wrapper_options
      @builder.text_field attribute_name, input_options(wrapper_options)
    end

    def hidden_field
      @builder.hidden_field "#{attribute_name}_id", id: id_field
    end

    def model
      attribute_name.to_s.classify.constantize
    end

    def url
      options.fetch(:url) { raise ArgumentError, 'You must supply a URL' }
    end

    def id_field
      "#{attribute_name}_id_#{object.object_id}"
    end

    def input_options wrapper_options
      {
        value:       object.send(attribute_name),
        title:       model.model_name.human,
        placeholder: model.model_name.human,
        data: {
          autocomplete_url: url,
          autocomplete_target: "##{id_field}"
        }
      }.deep_merge merge_wrapper_options(input_html_options, wrapper_options)
    end
end
