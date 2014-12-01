class <%= identity_model_class %> < ActiveRecord::Base

  include TokenVerification

  PASSWORD_RESET_KEY = :password_reset
  EMAIL_CONFIRMATION_KEY = :email_confirmation

  has_secure_password

  belongs_to :<%= domain_model %>, inverse_of: :<%= identity_model %>

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, allow_blank: true

  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of :password, within: 8..128, allow_blank: true

  def update_email(new_email)
    self.email = new_email
    if email_changed?
      self.confirmed_at = nil
      save && send_confirmation_email
    else
      save
    end
  end

  def confirm!
    self.confirmed_at = Time.current
    save(validate: false)
  end

  def confirmed?
    confirmed_at.present?
  end

  def send_confirmation_email
    <%= identity_mailer_class %>.confirm_email(self).deliver
  end

  def email_confirmation_token
    expires_at = 7.days.from_now
    expiration_token(expires_at, EMAIL_CONFIRMATION_KEY)
  end

  def password_reset_token
    expires_at = 1.day.from_now
    expiration_token(expires_at, PASSWORD_RESET_KEY)
  end


  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

end
