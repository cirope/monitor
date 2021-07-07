# frozen_string_literal: true

module RecordsHelper
  def record_kinds
    {
      login: Login.model_name.human(count: 0),
      fail:  Fail.model_name.human(count: 0)
    }
  end

  def record_user_name record
    record.user.present? ? record.user.username : record.data['user_name']
  end

  def record_human_data_names record
    record.data.each_with_object({}) do |(key, value), result|
      result[record.class.human_attribute_name key] = value
    end
  end
end
