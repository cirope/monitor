require 'test_helper'

class ScriptsControllerTest < ActionController::TestCase
  setup do
    @script = scripts :ls

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:scripts)
  end

  test 'should get filtered index for autocomplete' do
    get :index, q: @script.name, format: :json
    assert_response :success

    scripts = assigns :scripts
    assert_equal 1, scripts.size
    assert_equal @script.name, scripts.first.name
  end

  test 'should get filtered index' do
    get :index, filter: { name: 'undefined' }
    assert_response :success
    assert_not_nil assigns(:scripts)
    assert assigns(:scripts).empty?
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
      post :create, script: {
        name: 'Test script',
        file: @script.file,
        text: @script.text,
        change: @script.change,
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
    end

    assert_redirected_to script_url(assigns(:script))
  end

  test 'should show script' do
    get :show, id: @script
    assert_response :success
  end

  test 'should show script in PDF' do
    get :show, id: @script, format: :pdf
    assert_response :success
    assert_equal 'application/pdf', response.content_type
  end

  test 'should get edit' do
    get :edit, id: @script
    assert_response :success
  end

  test 'should update script' do
    patch :update, id: @script, script: { name: 'Updated text script' }
    assert_redirected_to script_url(assigns(:script))
  end

  test 'should destroy script' do
    @script = scripts :cd_root

    assert_difference 'Script.count', -1 do
      delete :destroy, id: @script
    end

    assert_redirected_to scripts_url
  end
end
