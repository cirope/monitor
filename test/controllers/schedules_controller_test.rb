# frozen_string_literal: true

require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  setup do
    @schedule = schedules :ls_on_atahualpa

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get filtered index for autocomplete' do
    get :index, params: { q: @schedule.name }, as: :json
    assert_response :success

    schedules = JSON.parse @response.body

    assert_equal 1, schedules.size
    assert_equal @schedule.name, schedules.first['name']
  end

  test 'should get filtered index' do
    get :index, params: { filter: { name: 'undefined' } }
    assert_response :success
    assert_select '.alert', text: I18n.t('schedules.index.empty_search_html')
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create schedule' do
    counts = [
      'Schedule.count',
      'Dependency.count',
      'Dispatcher.count',
      'Job.count'
    ]

    assert_difference counts do
      post :create, params: {
        schedule: {
          name:      @schedule.name,
          start:     @schedule.start,
          end:       @schedule.end,
          interval:  @schedule.interval,
          frequency: @schedule.frequency,
          jobs_attributes: [
            {
              server_id: servers(:atahualpa).id.to_s,
              script_id: scripts(:cd_root).id.to_s
            }
          ],
          dependencies_attributes: [
            {
              schedule_id: schedules(:ls_on_atahualpa).id.to_s
            }
          ],
          dispatchers_attributes: [
            {
              rule_id: rules(:cd_email).id.to_s
            }
          ]
        }
      }
    end

    assert_redirected_to schedule_url(Schedule.last)
  end

  test 'should show schedule' do
    get :show, params: { id: @schedule }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @schedule }
    assert_response :success
  end

  test 'should update schedule' do
    patch :update, params: {
      id: @schedule,
      schedule: { frequency: 'months' }
    }

    assert_redirected_to schedule_url(@schedule)
  end

  test 'should destroy schedule' do
    assert_difference 'Schedule.visible.count', -1 do
      delete :destroy, params: { id: @schedule }
    end

    assert_redirected_to schedules_url
  end

  test 'should schedule runs' do
    assert_difference '@schedule.runs.count'  do
      post :run, params: { id: @schedule }
    end

    assert_redirected_to schedule_runs_url(@schedule)
  end

  test 'should cleanup schedule' do
    should_destroy_count = @schedule.runs.executed.inject(0) do |memo, run|
      run.issues.empty? ? memo + 1 : memo
    end

    assert_not_equal 0, should_destroy_count

    assert_no_difference 'Schedule.visible.count' do
      assert_difference 'Run.count', -should_destroy_count do
        delete :cleanup, params: { id: @schedule }
      end
    end

    assert_redirected_to schedule_url(@schedule)
  end
end
