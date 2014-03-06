require 'active_support/concern'

module TokenVerification

  class ExpiredToken < StandardError; end

  PASSWORD_RESET = 'password_reset'
  EMAIL_CONFIRMATION = 'email_confirmation'

  extend ActiveSupport::Concern

  def password_reset_token
    verifier = self.class.verifier_for(PASSWORD_RESET)
    verifier.generate([id, Time.now])
  end

  def email_confirmation_token
    verifier = self.class.verifier_for(EMAIL_CONFIRMATION)
    verifier.generate([id, Time.now])
  end


  module ClassMethods

    def verifier_for(purpose)
      @verifiers ||= {}
      @verifiers.fetch(purpose) do |p|
        @verifiers[p] = Rails.application.message_verifier("#{self.name}-#{p.to_s}")
      end
    end

    def find_by_password_reset_token!(token)
      <%= domain_model_id %>, timestamp = self.class.verifier_for(PASSWORD_RESET).verify(token)
      raise ::TokenVerification::ExpiredToken if timestamp < 1.day.ago
      <% identity_model_class %>.find(<%= domain_model_id %>)
    end

    def find_by_email_confirmation!(token)
      <%= domain_model_id %>, timestamp = self.class.verifier_for(EMAIL_CONFIRMATION).verify(token)
      raise ::TokenVerification::ExpiredToken if timestamp < 1.day.ago
      <% identity_model_class %>.find(<%= domain_model_id %>)
    end

  end
end
