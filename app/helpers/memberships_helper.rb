# frozen_string_literal: true

module MembershipsHelper
  def link_to_default membership
    if membership.default
      content_tag :span, class: 'text-success', title: t('.default') do
        icon 'fas', 'toggle-on'
      end
    else
      options = {
        title: t('.make_default'),
        class: 'text-muted',
        data:  { remote: true, method: :patch }
      }

      link_to membership, options do
        icon 'fas', 'toggle-off'
      end
    end
  end

  def link_to_switch membership
    current = membership.account == current_account

    if current
      content_tag :span, nil, title: t('.current') do
        icon 'fas', 'sign-in-alt'
      end
    else
      options = {
        title: t('navigation.switch'),
        class: 'icon',
        data:  { method: :post }
      }

      link_to [membership, :switch_index], options do
        icon 'fas', 'sign-in-alt'
      end
    end
  end
end
