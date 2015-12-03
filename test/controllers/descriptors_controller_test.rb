require 'test_helper'

class DescriptorsControllerTest < ActionController::TestCase
  setup do
    @descriptor = descriptors :author

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:descriptors)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create descriptor' do
    assert_difference 'Descriptor.count' do
      post :create, descriptor: {
        name: 'New descriptor'
      }
    end

    assert_redirected_to descriptor_url(assigns(:descriptor))
  end

  test 'should show descriptor' do
    get :show, id: @descriptor
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @descriptor
    assert_response :success
  end

  test 'should update descriptor' do
    patch :update, id: @descriptor, descriptor: { name: 'Updated name' }
    assert_redirected_to descriptor_url(assigns(:descriptor))
  end

  test 'should destroy descriptor' do
    assert_difference 'Descriptor.count', -1 do
      delete :destroy, id: @descriptor
    end

    assert_redirected_to descriptors_url
  end
end
