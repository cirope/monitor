# frozen_string_literal: true

class Api::V1::Issues::Index
  def call(params)
    issues_validator = Api::V1::Issues::Validator.new(params)
    if issues_validator.valid?
      account = Account.find_by tenant_name: params[:account_id]
      account.switch!

      query = Issue.all
      query = Api::V1::Issues::Filter.new.call(query: query, params: params)
      construct(query)
    else
      issues_validator.errors
    end
  end

  private

    def construct(issues)
      if issues.can_collapse_data?
        data = issues.map { |issue| issue.converted_data.first.merge(status: issue.status) }
      else
        data = issues.map { |issue| issue.to_json }
      end

      Api::V1::StandardResponse.new.call(data: data, code: 200)
    end
end
