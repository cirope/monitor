# frozen_string_literal: true

require 'test_helper'

class ViewTest < ActiveSupport::TestCase
  test 'return views viewed by' do
    user = users :franco

    assert_equal View.viewed_by(user), View.where(user_id: user.id)
  end
end
