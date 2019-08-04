require 'test_helper'

class Servers::DefaultControllerTest < ActionController::TestCase
  setup do
    @server = servers :atahualpa

    login user: users(:god)
  end

  test 'should change default server' do
    old_default = @server
    new_default = servers :gardelito

    patch :update, params: { server_id: new_default.id }, xhr: true, as: :js

    assert_response :success
    assert new_default.reload.default
    refute old_default.reload.default
  end
end
