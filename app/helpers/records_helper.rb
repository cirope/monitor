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

  def data_translate record
    json = {}
    record.data.each_with_object(json) do |(key, value), json_hash|
      json_hash[record.class.human_attribute_name key.to_s] = value
    end
  end
end
