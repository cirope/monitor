namespace :db do
  desc 'Put records, remove and update the database using current app values'
  task update: :environment do
    ActiveRecord::Base.transaction do
      set_default_server  # 2019-02-28
      change_tags_style   # 2019-04-15
      set_issue_data_type # 2021-05-11
    end
  end
end

private

  def set_default_server
    Account.on_each do
      unless has_default_server?
        Server.find_each.any? do |server|
          server.update! default: true if server.local?
        end
      end
    end
  end

  def has_default_server?
    Server.where(default: true).exists?
  end

  def change_tags_style
    Account.on_each do
      if has_default_styled_tags?
        Tag.where(style: 'default').update_all style: 'secondary'
      end
    end
  end

  def has_default_styled_tags?
    Tag.where(style: 'default').any?
  end

  def set_issue_data_type
    PaperTrail.enabled = false

    Account.on_each do
      if set_issue_data_type?
        Issue.find_each do |issue|
          issue.data_will_change!

          issue.save!
        end
      end
    end
  ensure
    PaperTrail.enabled = true
  end

  def set_issue_data_type?
    Issue.where.not(data_type: nil).empty?
  end
