# frozen_string_literal: true

require 'test_helper'

class Scripts::ParametersControllerTest < ActionController::TestCase
  setup do
    @parameter = parameters :ls_dir

    login
  end

  test 'should get show' do
    get :show, params: {
      script_id: @parameter.script_id, id: @parameter
    }, xhr: true, as: :js

    assert_response :success
  end
end
