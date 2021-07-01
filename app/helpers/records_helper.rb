# frozen_string_literal: true

module RecordsHelper
  def record_kinds
    {
      login: Login.model_name.human(count: 0),
      fail: Fail.model_name.human(count: 0)
    }
  end

  def user_name_of_record record
    record.user.present? ? record.user.name : record.data['user_name']
  end
end
