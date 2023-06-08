# frozen_string_literal: true

require 'test_helper'

class ScriptsControllerTest < ActionController::TestCase
  setup do
    @script = scripts :ls

    login
  end

  teardown do
    Current.account = nil
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get filtered index for autocomplete' do
    get :index, params: { q: @script.name }, as: :json
    assert_response :success

    scripts = JSON.parse @response.body

    assert_equal 1, scripts.size
    assert_equal @script.name, scripts.first['name']
  end

  test 'should get filtered index' do
    get :index, params: { filter: { name: 'undefined' } }
    assert_response :success
    assert_select '.alert', text: I18n.t('scripts.index.empty_search_html')
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create script' do
    counts = [
      'Script.count',
      'Maintainer.count',
      'Require.count',
      'Tagging.count',
      'Parameter.count',
      'Description.count'
    ]

    assert_difference counts do
      post :create, params: {
          script: {
          name: 'Test script',
          text: @script.text,
          change: @script.change,
          libraries_attributes: [
            {
              name: 'bootstrap',
              options: '< 5'
            }
          ],
          maintainers_attributes: [
            {
              user_id: users(:eduardo).id.to_s
            }
          ],
          requires_attributes: [
            {
              script_id: scripts(:cd_root).id.to_s
            }
          ],
          taggings_attributes: [
            {
              tag_id: tags(:starters).id.to_s
            }
          ],
          parameters_attributes: [
            {
              name: 'Author',
              value: 'Franco Catena'
            }
          ],
          descriptions_attributes: [
            {
              name: 'Author',
              value: 'Franco Catena'
            }
          ]
        }
      }
    end

    assert_redirected_to script_url(Script.last)
  end

  test 'should show script' do
    get :show, params: { id: @script }
    assert_response :success
  end

  test 'should show script in PDF' do
    Current.account = send 'public.accounts', :default

    get :show, params: { id: @script }, as: :pdf
    assert_response :success
    assert_equal 'application/pdf', response.content_type
  end

  test 'should get edit' do
    get :edit, params: { id: @script }
    assert_response :success
  end

  test 'should update script' do
    patch :update, params: {
      id: @script,
      script: { name: 'Updated text script' }
    }

    assert_redirected_to script_url(@script)
  end

  test 'should destroy script' do
    @script = scripts :cd_root

    assert_difference 'Script.count', -1 do
      delete :destroy, params: { id: @script }
    end

    assert_redirected_to scripts_url
  end
end
