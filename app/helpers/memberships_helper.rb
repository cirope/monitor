module MembershipsHelper
  def link_to_switch membership
    current = membership.account == current_account

    if current
      content_tag :span, nil, title: current && t('.current') do
        content_tag :span, nil, class: 'glyphicon glyphicon-log-in'
      end
    else
      options = {
        title: t('navigation.switch'),
        class: 'icon',
        data:  {
          method: :post
        }
      }

      link_to [membership, :switch_index], options do
        content_tag :span, nil, class: 'glyphicon glyphicon-log-in'
      end
    end
  end
end
