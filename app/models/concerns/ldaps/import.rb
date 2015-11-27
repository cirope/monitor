module Ldaps::Import
  extend ActiveSupport::Concern

  def import username, password
    ldap        = ldap username, password
    ldap_filter = Net::LDAP::Filter.construct filter
    users_by_dn = {}
    users       = []

    User.transaction do
      ldap.search(base: basedn, filter: ldap_filter) do |entry|
        if entry[email_attribute].present?
          users << (result = process_entry entry)
          user   = result[:user]

          if user.persisted?
            users_by_dn[entry.dn] = user.id
          end
        end
      end

      raise Net::LDAP::Error.new unless ldap.get_operation_result.code == 0
    end

    users
  end

  private

    def process_entry entry
      data       = trivial_data entry
      user       = User.where(email: data[:email]).take
      new        = !user

      if user
        update_user user: user, data: data
      else
        user = create_user data: data
      end

      { user: user, new: new }
    end

    def trivial_data entry
      {
        username: entry[username_attribute].first.try(:force_encoding, 'UTF-8'),
        name:     entry[name_attribute].first.try(:force_encoding, 'UTF-8'),
        lastname: entry[lastname_attribute].first.try(:force_encoding, 'UTF-8'),
        email:    entry[email_attribute].first.try(:force_encoding, 'UTF-8')
      }
    end

    def update_user user: nil, data: nil
      user.update data
    end

    def create_user data: nil
      password = SecureRandom.urlsafe_base64

      User.create Hash(data).merge(
        password: password,
        password_confirmation: password
      )
    end
end
