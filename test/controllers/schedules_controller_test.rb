require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  setup do
    @schedule = schedules :ls_on_atahualpa

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:schedules)
  end

  test 'should filtered index' do
    get :index, q: @schedule.name, format: :json
    assert_response :success

    schedules = assigns :schedules
    assert_equal 1, schedules.size
    assert_equal @schedule.name, schedules.first.name
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
      'Job.count',
      'Tagging.count'
    ]

    assert_difference counts do
      post :create, schedule: {
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
        taggings_attributes: [
          {
            tag_id: tags(:starters).id.to_s
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
    end

    assert_redirected_to schedule_url(assigns(:schedule))
  end

  test 'should show schedule' do
    get :show, id: @schedule
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @schedule
    assert_response :success
  end

  test 'should update schedule' do
    patch :update, id: @schedule, schedule: { frequency: 'months' }
    assert_redirected_to schedule_url(assigns(:schedule))
  end

  test 'should destroy schedule' do
    assert_difference 'Schedule.count', -1 do
      delete :destroy, id: @schedule
    end

    assert_redirected_to schedules_url
  end

  test 'should schedule runs' do
    assert_difference '@schedule.runs.count'  do
      post :run, id: @schedule
    end

    assert_redirected_to schedule_runs_url(@schedule)
  end
end
