# frozen_string_literal: true

require 'test_helper'

class Scripts::MeasuresControllerTest < ActionController::TestCase
  setup do
    @measure = measures :live_ls_measure

    login
  end

  test 'should get index' do
    get :index, params: {
      type:      'execution',
      script_id: @measure.measurable.script_id
    }

    assert_response :success
  end
end
