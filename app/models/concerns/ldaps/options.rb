module Ldaps::Options
  extend ActiveSupport::Concern

  User::ROLES.each do |role|
    define_method "role_#{role}" do
      options && options[role]
    end

    define_method "role_#{role}=" do |value|
      self.options = (options || {}).merge(role => value)
    end
  end
end
