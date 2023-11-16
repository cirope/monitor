# frozen_string_literal: true

require 'test_helper'

class Rules::RevertsControllerTest < ActionController::TestCase
  setup do
    @trigger = triggers :email
    @version = versions :email_creation

    login
  end

  test 'should revert rule to version' do
    @trigger.update! callback: 'ls email'

    new_version = @trigger.versions.last

    post :create, params: { rule_id: @trigger.rule_id, id: new_version.id }
    assert_redirected_to rule_path(@trigger.rule_id)
  end

  test 'should not restore rule from version' do
    # default fixture version can not be restored
    post :create, params: { rule_id: @trigger.rule_id, id: @version }

    assert_redirected_to rule_version_path(@trigger.rule_id, @version.id)
  end
end
