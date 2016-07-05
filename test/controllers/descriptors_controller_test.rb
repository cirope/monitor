require 'test_helper'

class DescriptorsControllerTest < ActionController::TestCase
  setup do
    @descriptor = descriptors :author

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create descriptor' do
    assert_difference 'Descriptor.count' do
      post :create, params: {
        descriptor: {
          name: 'New descriptor'
        }
      }
    end

    assert_redirected_to descriptor_url(Descriptor.last)
  end

  test 'should show descriptor' do
    get :show, params: { id: @descriptor }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @descriptor }
    assert_response :success
  end

  test 'should update descriptor' do
    patch :update, params: {
      id: @descriptor,
      descriptor: { name: 'Updated name' }
    }

    assert_redirected_to descriptor_url(@descriptor)
  end

  test 'should destroy descriptor' do
    assert_difference 'Descriptor.count', -1 do
      delete :destroy, params: { id: @descriptor }
    end

    assert_redirected_to descriptors_url
  end
end
