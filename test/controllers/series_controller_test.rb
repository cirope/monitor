# frozen_string_literal: true

require 'test_helper'

class SeriesControllerTest < ActionController::TestCase

  setup do
    @serie = series :first_transaction

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should show serie' do
    get :show, params: { id: @serie }
    assert_response :success
  end
end
