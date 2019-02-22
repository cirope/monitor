ActiveRecord::Base.transaction do
  if Account.where(tenant_name: 'default').empty?
    Current.account = Account.create!(
      name:        Membership.human_attribute_name('default'),
      tenant_name: 'default'
    )

    Apartment::Tenant.switch Current.account.tenant_name do
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
