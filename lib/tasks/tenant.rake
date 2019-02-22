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
      ActiveRecord::Base.connection.execute <<-SQL
        INSERT INTO "#{schema}"."#{table}" SELECT * FROM "public"."#{table}";
      SQL

      ActiveRecord::Base.connection.reset_pk_sequence! "\"#{schema}\".\"#{table}\""
    end
  end

  def enroll_all_users_to account
    Apartment::Tenant.switch account.tenant_name do
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
    Apartment::Tenant.switch account.tenant_name do
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
