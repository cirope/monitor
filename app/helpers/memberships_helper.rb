module MembershipsHelper
  def link_to_switch membership
    unless membership.account == current_account
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
