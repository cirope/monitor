# frozen_string_literal: true

require 'test_helper'

class QueryTest < ActiveSupport::TestCase
  setup do
    @query = queries :one
  end

  test 'blank attributes' do
    @query.attr = ''

    assert @query.invalid?
    assert_error @query, :attr, :blank
  end

  test 'unique attributes' do
    query = @query.dup

    assert query.invalid?
    assert_error query, :attr, :taken
  end
end
