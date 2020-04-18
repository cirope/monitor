# frozen_string_literal: true

require 'test_helper'

class SerieTest < ActiveSupport::TestCase
  def setup
    @serie = series :first_transaction
  end

  test 'blank attributes' do
    @serie.name       = ''
    @serie.date       = ''
    @serie.identifier = ''
    @serie.amount     = ''
    @serie.count      = ''

    assert @serie.invalid?
    assert_error @serie, :name, :blank
    assert_error @serie, :date, :blank
    assert_error @serie, :identifier, :blank
    assert_error @serie, :amount, :blank
  end

  test 'numeric attributes' do
    @serie.amount = 'a'
    @serie.count  = 'a'

    assert @serie.invalid?
    assert_error @serie, :amount, :not_a_number
    assert_error @serie, :count, :not_a_number

    @serie.count = -1

    assert @serie.invalid?
    assert_error @serie, :count, :greater_than, count: 0

    @serie.count = 5.3

    assert @serie.invalid?
    assert_error @serie, :count, :not_an_integer
  end

  test 'increment' do
    assert_difference 'Serie.count' do
      Serie.increment(
        name:       'test',
        identifier: 'user_1',
        ts:         3.days.ago.to_i,
        amount:     3.54
      )
    end

    serie = Serie.find_by name: 'test'

    assert_equal 'test', serie.name
    assert_equal 'user_1', serie.identifier
    assert_equal 3.days.ago.to_date, serie.date.to_date
    assert_equal 3.54, serie.amount
    assert_equal 1, serie.count

    assert_no_difference 'Serie.count' do
      Serie.increment(
        name:       'test',
        identifier: 'user_1',
        ts:         3.days.ago.to_i,
        amount:     3.54,
        some_key:   'some value'
      )
    end

    serie.reload

    assert_equal 7.08, serie.amount
    assert_equal 2, serie.count
    assert_equal %w(some_key), serie.data.keys

    assert_no_difference 'Serie.count' do
      Serie.increment(
        name:       'test',
        identifier: 'user_1',
        ts:         3.days.ago.to_i,
        amount:     3.54,
        other_key:  'other value'
      )
    end

    serie.reload

    assert_equal 10.62, serie.amount
    assert_equal 3, serie.count
    assert_equal %w(other_key some_key), serie.data.keys.sort
  end
end
