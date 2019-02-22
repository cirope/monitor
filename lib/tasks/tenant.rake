namespace :tenant do
  desc 'Create default tenant and migrate current data to it'
  task default: :environment do
    unless default_tenant_exists?
      ActiveRecord::Base.transaction do
        account = create_default_account

        migrate_current_data_to account
        enroll_all_users_to     account
        assign_databases_to     account

        truncate_public_schema_data

        migrate_public_versions_data_from account
      end
    end
  end
end

private

  def default_tenant_exists?
    Account.where(tenant_name: 'default').exists?
  end

  def create_default_account
    Account.create! name:        Membership.human_attribute_name('default'),
                    tenant_name: 'default'
  end

  def migrate_current_data_to account
    schema = account.tenant_name

    tables.each do |table|
      columns = table_columns[table].map { |c| "\"#{c}\"" }

      ActiveRecord::Base.connection.execute <<-SQL
        INSERT INTO "#{schema}"."#{table}" (#{columns.join ', '})
          SELECT #{columns.join ', '} FROM "public"."#{table}";
      SQL

      ActiveRecord::Base.connection.reset_pk_sequence! "\"#{schema}\".\"#{table}\""
    end
  end

  def enroll_all_users_to account
    account.switch do
      User.all.each do |user|
        account.enroll user, default: true
      end
    end
  end

  def assign_databases_to account
    Database.update_all account_id: account.id
  end

  def truncate_public_schema_data
    tables.reverse.each do |table|
      ActiveRecord::Base.connection.execute <<-SQL
        TRUNCATE TABLE "public"."#{table}" RESTART IDENTITY CASCADE;
      SQL
    end
  end

  def migrate_public_versions_data_from account
    account.switch do
      versions = PaperTrail::Version.where(
        item_type: %w(Account Database Property Membership)
      ).order(:id)

      versions.each do |version|
        PublicVersion.create! version.attributes.except 'id'

        version.destroy!
      end
    end
  end

  def tables
    %w(
      descriptors
      ldaps
      permalinks
      rules
      schedules
      scripts
      servers
      tags
      users
      versions
      jobs
      triggers
      runs
      issues
      comments
      dependencies
      descriptions
      dispatchers
      executions
      issues_permalinks
      maintainers
      outputs
      parameters
      requires
      subscriptions
      taggings
    )
  end

  def table_columns
    {
      'descriptors' => [
        'id',
        'name',
        'lock_version',
        'created_at',
        'updated_at'
      ],
      'ldaps' => [
        'id',
        'hostname',
        'port',
        'basedn',
        'filter',
        'login_mask',
        'username_attribute',
        'name_attribute',
        'lastname_attribute',
        'email_attribute',
        'lock_version',
        'created_at',
        'updated_at',
        'options',
        'roles_attribute'
      ],
      'permalinks' => [
        'id',
        'token',
        'created_at',
        'updated_at'
      ],
      'rules' => [
        'id',
        'name',
        'enabled',
        'lock_version',
        'created_at',
        'updated_at',
        'uuid',
        'imported_at'
      ],
      'schedules' => [
        'id',
        'start',
        'end',
        'interval',
        'frequency',
        'lock_version',
        'created_at',
        'updated_at',
        'name',
        'scheduled_at',
        'hidden'
      ],
      'scripts' => [
        'id',
        'name',
        'file',
        'text',
        'lock_version',
        'created_at',
        'updated_at',
        'core',
        'change',
        'uuid',
        'imported_at'
      ],
      'servers' => [
        'id',
        'name',
        'hostname',
        'user',
        'password',
        'credential',
        'lock_version',
        'created_at',
        'updated_at'
      ],
      'tags' => [
        'id',
        'name',
        'lock_version',
        'created_at',
        'updated_at',
        'kind',
        'style',
        'options'
      ],
      'users' => [
        'id',
        'name',
        'lastname',
        'email',
        'password_digest',
        'created_at',
        'updated_at',
        'auth_token',
        'password_reset_token',
        'password_reset_sent_at',
        'lock_version',
        'role',
        'username',
        'hidden'
      ],
      'versions' => [
        'id',
        'item_type',
        'item_id',
        'event',
        'whodunnit',
        'object',
        'object_changes',
        'created_at'
      ],
      'jobs' => [
        'id',
        'schedule_id',
        'server_id',
        'script_id',
        'created_at',
        'updated_at',
        'hidden'
      ],
      'triggers' => [
        'id',
        'rule_id',
        'callback',
        'lock_version',
        'created_at',
        'updated_at',
        'uuid'
      ],
      'runs' => [
        'id',
        'status',
        'scheduled_at',
        'started_at',
        'ended_at',
        'output',
        'lock_version',
        'created_at',
        'updated_at',
        'job_id',
        'data'
      ],
      'issues' => [
        'id',
        'status',
        'description',
        'data',
        'run_id',
        'lock_version',
        'created_at',
        'updated_at'
      ],
      'comments' => [
        'id',
        'text',
        'user_id',
        'issue_id',
        'created_at',
        'updated_at',
        'file'
      ],
      'dependencies' => [
        'id',
        'dependent_id',
        'schedule_id',
        'created_at',
        'updated_at'
      ],
      'descriptions' => [
        'id',
        'name',
        'value',
        'script_id',
        'created_at',
        'updated_at'
      ],
      'dispatchers' => [
        'id',
        'schedule_id',
        'rule_id',
        'created_at',
        'updated_at'
      ],
      'executions' => [
        'id',
        'script_id',
        'server_id',
        'status',
        'started_at',
        'ended_at',
        'output',
        'user_id',
        'created_at',
        'updated_at'
      ],
      'issues_permalinks' => [
        'issue_id',
        'permalink_id'
      ],
      'maintainers' => [
        'id',
        'user_id',
        'script_id',
        'created_at',
        'updated_at'
      ],
      'outputs' => [
        'id',
        'text',
        'trigger_id',
        'run_id',
        'created_at',
        'updated_at'
      ],
      'parameters' => [
        'id',
        'name',
        'value',
        'script_id',
        'created_at',
        'updated_at'
      ],
      'requires' => [
        'id',
        'caller_id',
        'script_id',
        'created_at',
        'updated_at'
      ],
      'subscriptions' => [
        'id',
        'issue_id',
        'user_id',
        'created_at',
        'updated_at'
      ],
      'taggings' => [
        'id',
        'tag_id',
        'taggable_type',
        'taggable_id',
        'created_at',
        'updated_at'
      ]
    }
  end
