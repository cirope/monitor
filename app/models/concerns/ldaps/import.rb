module Ldaps::Import
  extend ActiveSupport::Concern

  def import username, password
    ldap        = ldap username, password
    ldap_filter = Net::LDAP::Filter.construct filter
    users       = []

    User.transaction do
      ldap.search(base: basedn, filter: ldap_filter) do |entry|
        if entry[email_attribute].present?
          users << (result = process_entry entry)
        end
      end

      raise Net::LDAP::Error.new unless ldap.get_operation_result.code == 0
    end

    users
  end

  private

    def process_entry entry
      data = extract_data entry
      user = User.where(email: data[:email]&.downcase).take
      new  = !user

      if user
        update_user user: user, data: data
      else
        user = create_user data: data
      end

      # update_tags user, entry

      { user: user, new: new }
    end

    def extract_data entry
      {
        username: entry[username_attribute].first&.force_encoding('UTF-8'),
        name:     entry[name_attribute].first&.force_encoding('UTF-8'),
        lastname: entry[lastname_attribute].first&.force_encoding('UTF-8'),
        email:    entry[email_attribute].first&.force_encoding('UTF-8'),
        role:     extract_role(entry),
        hidden:   false
      }
    end

    def extract_role entry
      role_names = roles_in entry

      User::ROLES.detect do |role|
        role_name = send "role_#{role}"

        role_names.include? role_name
      end
    end

    def update_user user: nil, data: nil
      user.update data
    end

    def create_user data: nil
      password = SecureRandom.urlsafe_base64

      User.create Hash(data).merge(
        password:              password,
        password_confirmation: password
      )
    end

    def update_tags user, entry
      roles_in(entry).each do |role_name|
        tag = tags[role_name]

        if tag && user.persisted?
          user.taggings.where(tag_id: tag.id).first_or_create! tag: tag
        end
      end
    end

    def roles_in entry
      entry[roles_attribute].map do |role|
        role&.force_encoding('UTF-8').sub(/.*?cn=(.*?),.*/i, '\1').to_s
      end
    end

    def tags
      Thread.current[:ldap_import_tags] ||=
        Hash[Tag.for_users.map { |tag| [tag.name, tag] }]
    end
end
