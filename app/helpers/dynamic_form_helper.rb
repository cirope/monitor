# frozen_string_literal: true

module DynamicFormHelper
  def link_to_add_fields name, form, association, options = {}
    link_to(
      name, '#',
      class: 'btn btn-secondary btn-sm',
      title: name,
      data: add_field_data(form, association, options)
    )
  end

  def link_to_remove_nested_item form
    out  = destroy_field(form) || ''
    out += link_to(
      remove_icon, '#',
      title: t('navigation.destroy'),
      data: remove_field_data(form),
      class: 'text-danger'
    )

    raw out
  end

  private

    def add_field_data form, association, options
      new_object = form.object.send(association).klass.new
      template   = fieldset(new_object, form, association, options)

      {
        id: new_object.object_id,
        dynamic_form_event: 'addNestedItem',
        dynamic_template: template.gsub("\n", '')
      }
    end

    def fieldset object, form, association, options
      form.fields_for(association, object, child_index: object.object_id) do |f|
        render object, options.merge(f: f)
      end
    end

    def remove_field_data form
      {
        dynamic_target: ".#{form.object.class.name.underscore}",
        dynamic_form_event: (form.object.new_record? ? 'removeItem' : 'hideItem'),
        show_tooltip: true
      }
    end

    def remove_icon
      icon 'far', 'times-circle'
    end

    def destroy_field form
      form.hidden_field(
        :_destroy,
        value: form.object.marked_for_destruction? ? 1 : 0,
        id: "destroy_hidden_#{form.object.id}",
        data: { destroy_field: true }
      ) if form.object.persisted?
    end
end
