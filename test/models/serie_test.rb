# frozen_string_literal: true

require 'test_helper'

class SerieTest < ActiveSupport::TestCase
  def setup
    @serie = series :first_transaction
  end

  test 'blank attributes' do
    @serie.name       = ''
    @serie.timestamp  = ''
    @serie.identifier = ''
    @serie.amount     = ''

    assert @serie.invalid?
    assert_error @serie, :name, :blank
    assert_error @serie, :timestamp, :blank
    assert_error @serie, :identifier, :blank
    assert_error @serie, :amount, :blank
  end

  test 'numeric attributes' do
    @serie.amount = 'a'

    assert @serie.invalid?
    assert_error @serie, :amount, :not_a_number
  end

  test 'create sample' do
    assert_difference 'Serie.count' do
      Serie.create_sample(
        name:       'test',
        identifier: 'user_1',
        timestamp:  3.days.ago.to_s(:db),
        amount:     3.54
      )
    end
  end

  test 'add series' do
    series = [
      {
        name:       'test2',
        identifier: 'user_2',
        timestamp:  1.days.ago.to_s(:db),
        amount:     1.11
      },
      {
        name:       'test2',
        identifier: 'user_2',
        timestamp:  2.days.ago.to_s(:db),
        amount:     2.22
      }
    ]


    assert_difference 'Serie.count', 2 do
      assert Serie.add series
    end
  end

  test 'partial add series' do
    series = [
      {
        name:       'test2',
        identifier: 'user_2',
        timestamp:  1.days.ago.to_s(:db),
        amount:     1.11
      },
      {
        name:       '',
        identifier: '',
        timestamp:  2.days.ago.to_s(:db)
      },
      {
        name:       'test3',
        identifier: 'user_3',
        timestamp:  3.days.ago.to_s(:db),
        amount:     3.33
      }
    ]

    assert_difference 'Serie.count', 2 do
      refute Serie.add series
    end
  end
end
