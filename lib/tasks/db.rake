namespace :db do
  desc 'Put records, remove and update the database using current app values'
  task update: :environment do
    ActiveRecord::Base.transaction do
      set_default_server         # 2019-02-28
      change_tags_style          # 2019-04-15
      set_issue_data_type        # 2021-05-11
      generate_state_transitions # 2021-10-29
      set_issue_canonical_data   # 2022-02-01
      encrypt_property_passwords # 2022-05-27
      roles_migration            # 2023-18-01
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

  def generate_state_transitions
    unless state_transitions_were_generated?
      Account.on_each do
        Issue.find_each do |issue|
          state_transitions_hash = {}

          issue.versions.find_each do |version|
            if version.object_changes.key? 'status'
              date_time_state_transition = DateTime.parse(version.object_changes['updated_at'][1]).to_s :db
              new_status                 = version.object_changes['status'][1]

              unless state_transitions_hash.key?(new_status) && date_time_state_transition < DateTime.parse(state_transitions_hash[new_status])
                state_transitions_hash[new_status] = date_time_state_transition
              end
            end
          end

          issue.update_attribute('state_transitions', state_transitions_hash)
        end
      end
    end
  end

  def state_transitions_were_generated?
    Issue.where.not(state_transitions: {}).any?
  end

  def set_issue_canonical_data
    PaperTrail.enabled = false

    Account.on_each do
      if set_issue_canonical_data?
        Issue.single_row_data_type.find_each do |issue|
          issue.data_will_change!

          issue.save!
        end
      end
    end
  ensure
    PaperTrail.enabled = true
  end

  def set_issue_canonical_data?
    Issue.where.not(canonical_data: nil).empty?
  end

  def encrypt_property_passwords
    PaperTrail.enabled = false

    Property.find_each do |property|
      if property.password? && property.value.present?
        begin
          ::Security.decrypt(property.value)
        rescue
          property.update_column :value, ::Security.encrypt(property.value)
        end
      end
    end
  ensure
    PaperTrail.enabled = true
  end

  def roles_migration
    Account.on_each do
      unless Role.exists?
        ROLES.each do |old_role, params|
          if role = Role.create(params)
            User.where(old_role: old_role).update_all role_id: role.id
          end
        end
      end
    end
  end
