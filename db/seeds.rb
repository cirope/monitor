# frozen_string_literal: true

ActiveRecord::Base.transaction do
  account = Account.where(tenant_name: 'default').first_or_create!(
    name: Membership.human_attribute_name('default')
  )
  account.switch do
    return if User.exists? email: 'admin@monitor.com'

    role = Role.find_by type: 'supervisor'

    User.create!(
      name:                  'Admin',
      lastname:              'Admin',
      username:              'admin',
      email:                 'admin@monitor.com',
      role:                  role,
      password:              '123',
      password_confirmation: '123'
    )
  end
end
