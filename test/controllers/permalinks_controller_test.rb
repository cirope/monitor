require 'test_helper'

class PermalinksControllerTest < ActionController::TestCase
  setup do
    @permalink = permalinks :link

    login
  end

  test 'should create permalink' do
    assert_difference 'Permalink.count' do
      post :create, params: {
        permalink: {
          token: nil,
          issue_ids: [
            issues(:ls_on_atahualpa_not_well).id.to_s
          ]
        }
      }, as: :js
    end

    assert_response :success
    assert_equal 1, Permalink.last.issues.count
  end

  test 'should show permalink' do
    get :show, params: { id: @permalink }

    assert_response :success
  end
end
