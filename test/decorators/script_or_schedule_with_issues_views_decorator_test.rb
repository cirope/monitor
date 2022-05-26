# frozen_string_literal: true

require 'test_helper'

class ScriptOrScheduleWithIssuesViewsDecoratorTest < ActiveSupport::TestCase
  test 'should get script with all issues views' do
    View.create! issue: issues(:ls_on_atahualpa_not_well_again),
                 user: users(:franco)

    script          = scripts :ls
    user            = users(:franco)
    expected_return = [[[script.id, script.name], script.issues.count, 0]]

    issues_grouped_by_script_and_views = Issue.grouped_by_script_and_views(nil, user).count

    assert_equal expected_return,
                 ScriptOrScheduleWithIssuesViewsDecorator.new(issues_grouped_by_script_and_views).to_a
  end

  test 'should get script with some issues views' do
    script          = scripts :ls
    user            = users(:franco)
    expected_return = [[[script.id, script.name], script.issues.count, user.views.count]]

    issues_grouped_by_script_and_views = Issue.grouped_by_script_and_views(nil, user).count

    assert_equal expected_return,
                 ScriptOrScheduleWithIssuesViewsDecorator.new(issues_grouped_by_script_and_views).to_a
  end

  test 'should get script with none issues views' do
    views(:franco_view_ls).delete

    script          = scripts :ls
    user            = users(:franco)
    expected_return = [[[script.id, script.name], script.issues.count, script.issues.count]]

    issues_grouped_by_script_and_views = Issue.grouped_by_script_and_views(nil, user).count

    assert_equal expected_return,
                 ScriptOrScheduleWithIssuesViewsDecorator.new(issues_grouped_by_script_and_views).to_a
  end
end
