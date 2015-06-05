json.array!(@ldaps) do |ldap|
  json.extract! ldap, :id, :hostname, :port, :basedn, :filter, :login_mask, :username_attribute, :name_attribute, :lastname_attribute, :email_attribute
  json.url ldap_url(ldap, format: :json)
end
