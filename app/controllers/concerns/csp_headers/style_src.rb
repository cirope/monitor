module CspHeaders::StyleSrc
  extend ActiveSupport::Concern

  included do
    content_security_policy do |policy|
      policy.style_src :self, :unsafe_inline
    end
  end
end
