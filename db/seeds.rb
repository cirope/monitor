ActiveRecord::Base.transaction do
  if Account.where(tenant_name: 'default').empty?
    account = Account.create!(
      name:        Membership.human_attribute_name('default'),
      tenant_name: 'default'
    )

    account.switch do
      User.create!(
        name:                  'Admin',
        lastname:              'Admin',
        username:              'admin',
        email:                 'admin@monitor.com',
        role:                  'supervisor',
        password:              '123',
        password_confirmation: '123'
      )
    end
  end
end
