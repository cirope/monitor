# frozen_string_literal: true

module RecordsHelper
  def record_kinds
    {
      login: Login.model_name.human(count: 0),
      fail:  Fail.model_name.human(count: 0)
    }
  end

  def record_user_name record
    record.user.present? ? record.user.name : record.data['user_name']
  end
end
