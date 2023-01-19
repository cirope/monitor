module Samls::Options
  extend ActiveSupport::Concern

  ROLES.keys.each do |role|
    define_method "role_#{role}" do
      options && options[role]
    end

    define_method "role_#{role}=" do |value|
      self.options = (options || {}).merge(role => value)
    end
  end
end
