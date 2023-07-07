module Users::Restore
  extend ActiveSupport::Concern

  attr_accessor :restore

  def restore?
    restore == '1' || restore == true
  end

  def restore_errors_any?
    find_hidden_user &&
      (
        errors.where(:email, :taken).present? ||
        (errors.where(:username, :taken).present? if username.present?)
      )
  end

  def find_and_restore!
    user = find_hidden_user

    if validate_unique_user_to_restore(user)
        attrs          = attributes.select { |attr, value| value.present? }
        new_attributes = attrs.slice(
          :name, :lastname, :username, :email, :role_id
        ).merge hidden: false, restore: true

        user.attributes = new_attributes

        user.save!

        Current.account.enroll user

        user
    else
      errors.add :restore, I18n.t('users.restore.error')

      self
    end
  end

  private

    def find_hidden_user
      (User.find_by(email: email, hidden: true) if email.present?) ||
        (User.find_by(username: username, hidden: true) if username.present?)
    end

    def validate_unique_user_to_restore user
      valid_username = username.present? ? user.username == username : true
      valid_email    = email.present?    ? user.email    == email    : true

      valid_username && valid_email
    end
end
