# frozen_string_literal: true

require 'test_helper'

class QueryTest < ActiveSupport::TestCase
  setup do
    @query = queries :count_to_be_used
  end

  test 'blank attributes' do
    @query.output = ''

    assert @query.invalid?
    assert_error @query, :output, :blank
  end
end
