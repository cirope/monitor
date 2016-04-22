require 'test_helper'

class PermalinksControllerTest < ActionController::TestCase
  setup do
    @permalink = permalinks :link

    login
  end

  test 'should create permalink' do
    assert_difference 'Permalink.count' do
      post :create, format: :js, permalink: {
        token: nil,
        issue_ids: [
          issues(:ls_on_atahualpa_not_well).id.to_s
        ]
      }
    end

    assert_template 'permalinks/create'
    assert_equal 1, assigns(:permalink).issues.count
  end

  test 'should show permalink' do
    get :show, id: @permalink

    assert_response :success
  end
end
