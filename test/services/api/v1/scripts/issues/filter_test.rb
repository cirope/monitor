# frozen_string_literal: true

require 'test_helper'

class Api::V1::Scripts::Issues::FilterTest < ActiveSupport::TestCase
  setup do
    Current.account = send 'public.accounts', :default

    Current.account.switch!
  end

  test 'default issues' do
    params = ActionController::Parameters.new
    query  = Issue.all

    assert_equal query, Api::V1::Scripts::Issues::Filter.new.call(query: query, params: params)
  end

  test 'script issues' do
    script = scripts :ls
    params = ActionController::Parameters.new(script_id: script.id)

    assert_equal script.issues.order(:id),
                 Api::V1::Scripts::Issues::Filter.new.call(query: Issue.all, params: params).order(:id)
  end

  test 'empty issues' do
    script = scripts :cd_root
    params = ActionController::Parameters.new(script_id: script.id)

    assert_empty Api::V1::Scripts::Issues::Filter.new.call(query: Issue.all, params: params)
  end
end
