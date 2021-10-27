# frozen_string_literal: true

class Api::V1::Scripts::IssuesByStatus::Index
  def call
    query = Script.all

    construct query
  end

  private

    def construct scripts
      data = scripts.each_with_object({}) do |script, hsh|
        hsh[script.name] = status_of_issues script.issues
      end

      Api::V1::StandardResponse.new.call data: data, code: 200
    end

    def status_of_issues issues
      hash_of_status = initialize_hash_of_status.merge issues.group(:status).count

      hash_of_status.deep_transform_keys { |key| I18n.t("issues.status.#{key}") }
    end

    def initialize_hash_of_status
      Issue.statuses.each_with_object({}) { |status, hsh| hsh[status] = 0 }
    end
end
