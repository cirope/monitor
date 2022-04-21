# frozen_string_literal: true

require 'test_helper'

class EffectTest < ActiveSupport::TestCase
  setup do
    @effect = effects :important_final
  end

  test 'blank attributes' do
    @effect.tag     = nil
    @effect.implied = nil

    assert @effect.invalid?
    assert_error @effect, :tag, :required
    assert_error @effect, :implied, :required
  end

  test 'invalid attributes' do
    @effect.implied = @effect.tag

    assert @effect.invalid?
    assert_error @effect, :implied, :invalid
  end
end
