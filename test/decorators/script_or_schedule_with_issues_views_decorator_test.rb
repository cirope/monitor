# frozen_string_literal: true

require 'test_helper'

class ScriptOrScheduleWithIssuesViewsDecoratorTest < ActiveSupport::TestCase
  test 'should get script with all issues views' do
    View.create! issue: issues(:ls_on_atahualpa_not_well_again),
                 user: users(:franco)

    script          = scripts :ls
    script_boom     = scripts :boom
    user            = users(:franco)
    expected_return = [
      [[script.id, script.name], script.issues.count, 0],
      [[script_boom.id, script_boom.name], script_boom.issues.count, 1]
    ]

    issues_grouped_by_script_and_views = Issue.grouped_by_script_and_views(nil, user).count

    assert_equal expected_return,
                 ScriptOrScheduleWithIssuesViewsDecorator.new(issues_grouped_by_script_and_views).to_a
  end

  test 'should get script with some issues views' do
    script          = scripts :ls
    script_boom     = scripts :boom
    user            = users(:franco)
    expected_return = [
      [[script.id, script.name], script.issues.count, user.views.count],
      [[script_boom.id, script_boom.name], script_boom.issues.count, user.views.count]
    ]

    issues_grouped_by_script_and_views = Issue.grouped_by_script_and_views(nil, user).count

    assert_equal expected_return,
                 ScriptOrScheduleWithIssuesViewsDecorator.new(issues_grouped_by_script_and_views).to_a
  end

  test 'should get script with none issues views' do
    views(:franco_view_ls).delete

    script          = scripts :ls
    script_boom     = scripts :boom
    user            = users(:franco)
    expected_return = [
      [[script.id, script.name], script.issues.count, script.issues.count],
      [[script_boom.id, script_boom.name], script_boom.issues.count, script_boom.issues.count]
    ]

    issues_grouped_by_script_and_views = Issue.grouped_by_script_and_views(nil, user).count

    assert_equal expected_return,
                 ScriptOrScheduleWithIssuesViewsDecorator.new(issues_grouped_by_script_and_views).to_a
  end
end
