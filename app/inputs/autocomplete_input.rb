# frozen_string_literal: true

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
      hidden_input_html    = Hash options[:hidden_input_html]
      hidden_input_options = { id: id_field }.merge(hidden_input_html)

      @builder.hidden_field "#{attribute_name}_id", hidden_input_options
    end

    def model
      attribute_name.to_s.classify.constantize
    rescue
      object.class.reflect_on_association(attribute_name).class_name.constantize
    end

    def url
      options.fetch(:url) { raise ArgumentError, 'You must supply a URL' }
    end

    def id_field
      "#{attribute_name}_id_#{object.object_id}"
    end

    def input_options wrapper_options
      value   = object.respond_to?(attribute_name) ? object.send(attribute_name) : nil
      options = merge_wrapper_options input_html_options, wrapper_options

      {
        value:       value,
        title:       model.model_name.human,
        placeholder: model.model_name.human,
        data: {
          autocomplete_url:    url,
          autocomplete_target: "##{id_field}"
        }
      }.deep_merge options
    end
end
