class <%= identity_model_class %>Notifier < ActionMailer::Base

  def reset_password(<%= identity_model %>)
    @<%= identity_model %> = <% identity_model %>
    @reset_password_url = password_reset_url(token: @<%= identity_model %>.password_reset_token)
    mail(to: <%= identity_model %>.email, subject: "Resetting your password")
  end

end
