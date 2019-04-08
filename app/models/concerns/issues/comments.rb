# frozen_string_literal: true

module Issues::Comments
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :destroy
    has_one :last_comment, -> {
      includes(:user).reorder created_at: :desc
    }, class_name: 'Comment'

    accepts_nested_attributes_for :comments, reject_if: :all_blank
  end

  module ClassMethods
    def comment attributes
      comment = nil

      transaction do
        find_each do |issue|
          comment = issue.comments.create! attributes.merge(notify: false)
        end
      end

      notify_new_comment comment if comment
    end

    private

      def notify_new_comment comment
        user_ids = user_ids_for comment

        user_ids.each do |user_id|
          user      = User.find user_id
          permalink = Permalink.create! issue_ids: issue_ids_for(user_id)

          Notifier.mass_comment(user:      user,
                                comment:   comment,
                                permalink: permalink).deliver_later
        end
      end

      def user_ids_for comment
        column = Arel.sql "#{User.quoted_table_name}.id"

        left_joins(:users).
          where.not(users: { id: comment.user_id }).
          references(:users).
          distinct(column).
          pluck(column).
          compact
      end

      def issue_ids_for user_id
        left_joins(:users).references(:users).where(users: { id: user_id }).ids
      end
  end
end
