# frozen_string_literal: true

class Api::V1::Issues::Index
  def call params, current_user
    issues_validator = Api::V1::Issues::Validator.new params

    if issues_validator.valid?
      issues = current_user.can_use_mine_filter? ? Issue.all : current_user.issues

      query = Api::V1::Issues::Filter.new.call(query: issues, params: params)

      construct query
    else
      issues_validator.errors
    end
  end

  private

    def construct issues
      if issues.can_collapse_data?
        data = contruct_collapse_data issues
      else
        data = issues.to_json methods: :url, except: %i[data options run_id]
      end

      Api::V1::StandardResponse.new.call data: data, code: 200
    end

    def contruct_collapse_data issues
      issues.includes(:users, :tags).map do |issue|
        issue.converted_data.first.merge Issue.human_attribute_name('status') => I18n.t("issues.status.#{issue.status}"),
                                         url: issue.url,
                                         I18n.t('api.v1.issues.keys.tags') => title_tags(issue.tags.reject(&:final?)),
                                         I18n.t('api.v1.issues.keys.final_tags') => title_tags(issue.tags.select(&:final?)),
                                         I18n.t('api.v1.issues.keys.category_tags') => title_tags(issue.tags.select(&:category?)),
                                         Issue.human_attribute_name('description') => issue.description,
                                         Issue.human_attribute_name('created_at') => I18n.l(issue.created_at, format: :compact),
                                         Issue.human_attribute_name('updated_at') => I18n.l(issue.updated_at, format: :compact),
                                         I18n.t('api.v1.issues.keys.auditor') => issue.users.detect(&:manager?).to_s,
                                         I18n.t('api.v1.issues.keys.audited') => issue.users.detect(&:owner?).to_s
      end
    end

    def title_tags tags
      tags.collect(&:name).join(', ')
    end
end
