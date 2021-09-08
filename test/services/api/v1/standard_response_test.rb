# frozen_string_literal: true

require 'test_helper'

class Api::V1::StandardResponseTest < ActiveSupport::TestCase
  test 'call with data and code' do
    assert_equal Api::V1::StandardResponse.new.call(data: 'a data', code: 200),
                 { data: 'a data', code: 200 }
  end
end
