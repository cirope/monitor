# frozen_string_literal: true

module LinksHelper
  def link_to_destroy(*args)
    if current_user.can? :remove, controller_path
      options = args.extract_options!

      options[:data]           ||= {}
      options[:data][:method]  ||= :delete
      options[:data][:confirm] ||= t('messages.confirmation')

      link_with_icon({ action: 'destroy', icon: 'trash' }, *(args << options))
    end
  end

  def link_to_edit *args
    link_with_icon({ action: 'edit', icon: 'pen' }, *args) if current_user.can? :edit, controller_path
  end

  def link_to_index *args
    link_to t('navigation.index'), *args if current_user.can? :read, controller_path
  end

  def link_to_new *args
    link_to t('.new'), *args if current_user.can? :edit, controller_path
  end

  def link_to_show *args
    link_with_icon({ action: 'show', icon: 'search' }, *args) if current_user.can? :read, controller_path
  end

  private

    def link_with_icon(options = {}, *args)
      arg_options = args.extract_options!
      title = options.fetch(:title) { t("navigation.#{options.fetch :action}") }

      arg_options.reverse_merge! title: title, class: 'icon'

      link_to *args, arg_options do
        icon 'fas', options.fetch(:icon)
      end
    end
end
