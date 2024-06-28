namespace :db do
  desc 'Put records, remove and update the database using current app values'
  task update: :environment do
    ActiveRecord::Base.transaction do
      set_default_server             # 2019-02-28
      change_tags_style              # 2019-04-15
      set_issue_data_type            # 2021-05-11
      generate_state_transitions     # 2021-10-29
      set_issue_canonical_data       # 2022-02-01
      encrypt_property_passwords     # 2022-05-27
      roles_migration                # 2023-01-18
      add_tickets_to_roles           # 2023-04-18
      merge_triggers_on_rules        # 2023-10-18
      copy_script_and_server_to_runs # 2024-06-10
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
    PaperTrail.enabled = false

    Account.on_each do
      unless Role.exists?
        service = Ldap.default || Saml.default

        ROLES.each do |old_role, params|
          options    = { type: old_role }
          identifier = service.options[old_role.to_s] if service

          options.merge!(identifier: identifier) if identifier.present?

          if (role = Role.create(params.merge(options))).persisted?
            User.where(old_role: old_role).update_all role_id: role.id
          end
        end
      end
    end
  ensure
    PaperTrail.enabled = true
  end

  def add_tickets_to_roles
    PaperTrail.enabled = false

    Account.on_each do
      Role.all.each do |role|
        ticket = role.permissions.find_by section: 'Ticket'
        issue  = role.permissions.find_by section: 'Issue'

        if !ticket && issue
          role.permissions.create!(
            section: 'Ticket',
            read:    issue.read,
            edit:    issue.edit,
            remove:  issue.remove
          )
        end
      end
    end
  ensure
    PaperTrail.enabled = true
  end

  def merge_triggers_on_rules
    Account.on_each do
      if should_merge_triggers_on_rules?
        Rule.find_each do |rule|
          triggers = rule.triggers.order(id: :asc)

          if triggers.count > 1
            main_trigger = triggers.first
            callbacks    = triggers.map(&:callback).join "\r\n"

            main_trigger.update_column :callback, callbacks

            triggers.where.not(id: main_trigger.id).map &:destroy
          end
        end
      end
    end
  end

  def should_merge_triggers_on_rules?
    Trigger.group('rule_id').count.values.any? { |value| value > 1 }
  end

  def copy_script_and_server_to_runs
    Account.on_each do
      if should_copy_script_and_server_to_runs?
        Run.find_each do |run|
          if job = run.job
            run.update_columns(
              script_id: job.script_id,
              server_id: job.server_id
            )
          end
        end
      end
    end
  end

  def should_copy_script_and_server_to_runs?
    Run.where.not(script: nil, server: nil).empty?
  end
