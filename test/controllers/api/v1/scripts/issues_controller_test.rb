# frozen_string_literal: true

require 'test_helper'

class Api::V1::Scripts::IssuesControllerTest < ActionController::TestCase
  setup do
    @script  = scripts :ls

    @account = send 'public.accounts', :default

    @user_view_all_issues    = users :franco
    @user_view_filter_issues = users :john
    @user_without_issues     = users :god

    exp = 1.month.from_now

    @token_with_user_view_all_issues    = Api::V1::AuthenticateUser.new(@user_view_all_issues,
                                                                        @account,
                                                                        exp)
                                                                   .call
                                                                   .result
    @token_with_user_view_filter_issues = Api::V1::AuthenticateUser.new(@user_view_filter_issues,
                                                                        @account,
                                                                        exp)
                                                                   .call
                                                                   .result
    @token_with_user_without_issues     = Api::V1::AuthenticateUser.new(@user_without_issues,
                                                                        @account,
                                                                        exp)
                                                                   .call
                                                                   .result
  end

  test 'index return error with invalid script' do
    request.headers['Authorization'] = @token_with_user_view_all_issues
    get :index, params: { script_id: 'a' }

    assert_response :missing
    assert_match I18n.t('api.v1.issues.script_incorrect'), response.body
    assert_match I18n.t('api.v1.issues.script_not_exist'), response.body
  end

  test 'index return error with non existent script' do
    request.headers['Authorization'] = @token_with_user_view_all_issues
    get :index, params: { script_id: Script.last.id + 1 }

    assert_response :missing
    assert_match I18n.t('api.v1.issues.script_not_exist'), response.body
  end

  test 'index empty data for user with filter and without issues' do
    request.headers['Authorization'] = @token_with_user_without_issues
    get :index, params: { script_id: @script.id }

    assert_response :success
    assert_match [].to_json, response.body
  end

  test 'index without colapse data, for user with filter' do
    request.headers['Authorization'] = @token_with_user_view_filter_issues
    get :index, params: { script_id: @script.id }

    assert_response :success

    json_expected = @user_view_filter_issues.issues
                                            .script_id_scoped(@script.id)
                                            .to_json(methods: :url, except: %i[options run_id])
    assert_match json_expected, response.body
  end

  test 'index with colapse data' do
    @script.issues.each do |issue|
      issue.update! data: [['Header'], ['Value']]
    end

    request.headers['Authorization'] = @token_with_user_view_filter_issues
    get :index, params: { script_id: @script.id }

    assert_response :success

    json_expected = @user_view_filter_issues.issues
                                            .script_id_scoped(@script.id)
                                            .map do |issue|
                                              issue.converted_data
                                                   .first
                                                   .merge Issue.human_attribute_name('status') => I18n.t("issues.status.#{issue.status}"),
                                                          url: issue.url,
                                                          I18n.t('api.v1.issues.keys.tags') => issue.tags.reject(&:final?).collect(&:name).join(', '),
                                                          I18n.t('api.v1.issues.keys.final_tags') => issue.tags.select(&:final?).collect(&:name).join(', '),
                                                          I18n.t('api.v1.issues.keys.category_tags') => issue.tags.select(&:category?).join(', '),
                                                          Issue.human_attribute_name('description') => issue.description,
                                                          Issue.human_attribute_name('created_at') => I18n.l(issue.created_at, format: :compact),
                                                          Issue.human_attribute_name('updated_at') => I18n.l(issue.updated_at, format: :compact),
                                                          I18n.t('api.v1.issues.keys.auditor') => issue.users.detect(&:manager?).to_s,
                                                          I18n.t('api.v1.issues.keys.audited') => issue.users.detect(&:owner?).to_s,
                                                          Issue.human_attribute_name('state_transitions') => convert_state_transtions(issue.state_transitions)
                                            end
                                            .to_json

    assert_match json_expected, response.body
  end

  test 'index empty data for user without filter and script without issues' do
    script_without_issues = scripts :cd_root

    request.headers['Authorization'] = @token_with_user_view_all_issues
    get :index, params: { script_id: script_without_issues.id }

    assert_response :success
    assert_match [].to_json, response.body
  end

  test 'index without colapse data, for user without filter' do
    request.headers['Authorization'] = @token_with_user_view_all_issues
    get :index, params: { script_id: @script.id }

    assert_response :success

    json_expected = @script.issues.to_json(methods: :url, except: %i[options run_id])
    assert_match json_expected, response.body
  end

  test 'index with colapse data, for user without filter' do
    @script.issues.each do |issue|
      issue.update! data: [['Header'], ['Value']]
    end

    request.headers['Authorization'] = @token_with_user_view_all_issues
    get :index, params: { script_id: @script.id }

    assert_response :success

    json_expected = @script.issues
                           .map do |issue|
                             issue.converted_data
                                  .first
                                  .merge Issue.human_attribute_name('status') => I18n.t("issues.status.#{issue.status}"),
                                         url: issue.url,
                                         I18n.t('api.v1.issues.keys.tags') => issue.tags.reject(&:final?).collect(&:name).join(', '),
                                         I18n.t('api.v1.issues.keys.final_tags') => issue.tags.select(&:final?).collect(&:name).join(', '),
                                         I18n.t('api.v1.issues.keys.category_tags') => issue.tags.select(&:category?).join(', '),
                                         Issue.human_attribute_name('description') => issue.description,
                                         Issue.human_attribute_name('created_at') => I18n.l(issue.created_at, format: :compact),
                                         Issue.human_attribute_name('updated_at') => I18n.l(issue.updated_at, format: :compact),
                                         I18n.t('api.v1.issues.keys.auditor') => issue.users.detect(&:manager?).to_s,
                                         I18n.t('api.v1.issues.keys.audited') => issue.users.detect(&:owner?).to_s,
                                         Issue.human_attribute_name('state_transitions') => convert_state_transtions(issue.state_transitions)
                           end
                           .to_json

    assert_match json_expected, response.body
  end

  private

    def convert_state_transtions state_transitions
      state_transitions.each { |k, v| state_transitions[k] = I18n.l(DateTime.parse(v), format: :compact) }
  
      state_transitions.deep_transform_keys { |key| I18n.t "issues.status.#{key}" }
    end
end
