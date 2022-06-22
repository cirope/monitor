json.array!(@samls) do |saml|
  json.extract! saml, :id, :provider, :username_attribute, :name_attribute, :lastname_attribute, :email_attribute
  json.url saml_url(saml, format: :json)
end
