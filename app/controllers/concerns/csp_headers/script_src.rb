module CspHeaders::ScriptSrc
  extend ActiveSupport::Concern

  included do
    content_security_policy do |policy|
      policy.script_src :self, :unsafe_inline
      policy.script_src_elem :self, :unsafe_inline
      policy.script_src_attr :self, :unsafe_inline
    end
  end
end
