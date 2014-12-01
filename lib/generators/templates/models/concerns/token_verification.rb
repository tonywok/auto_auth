require 'active_support/concern'

module TokenVerification

  class ExpiredToken < StandardError; end

  extend ActiveSupport::Concern

  def expiration_token(expires_at, purpose)
    verifier = self.class.verifier_for(purpose)
    verifier.generate({ id: id, expires_at: expires_at })
  end


  module ClassMethods

    def verifier_for(purpose)
      @verifiers ||= {}
      @verifiers.fetch(purpose) do |p|
        @verifiers[p] = Rails.application.message_verifier("#{self.name}-#{p.to_s}")
      end
    end

    def verify_signature!(purpose, token)
      data = self.verifier_for(purpose).verify(token)
      record = self.find(data[:id])
      record.tap do
        if block_given?
          yield(record, data[:expires_at])
        end
      end
    end

  end
end
