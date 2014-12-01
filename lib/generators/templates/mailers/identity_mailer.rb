class <%= identity_mailer_class %> < ActionMailer::Base

  def reset_password(<%= identity_model %>)
    @<%= identity_model %> = <%= identity_model %>
    @reset_password_url = edit_password_url(<%= identity_model %>, password_reset_token: @<%= identity_model %>.password_reset_token)
    mail(to: <%= identity_model %>.email, subject: t(:'auto_auth.mailers.reset_password.subject'))
  end

  def confirm_email(<%= identity_model %>)
    @<%= identity_model %> = <%= identity_model %>
    @confirm_email_url = confirm_registrations_url(email_confirmation_token: @<%= identity_model %>.email_confirmation_token)
    mail(to: <%= identity_model %>.email, subject: t(:'auto_auth.mailers.confirm_email.subject'))
  end

end
