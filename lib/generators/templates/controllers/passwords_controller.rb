class PasswordsController < ApplicationController

  def create
    <%= identity_model %> = <%= identity_model_class %>.find_by(email: params.require(:email))
    <%= identity_model_class %>Notifier.reset_password(<%= identity_model %>).deliver
    redirect_to root_url, notice: "Check your email for password reset instructions"
  end

  def show
    @<%= identity_model %> = <%= identity_model_class %>.find_by_password_reset_token!(params.require(:token))
  end

  def update
    <%= identity_model_class %>.find_by_password_reset_token!(params.require(:token)).update!(
      password: params.require(:new_password),
      password_confirmation: params.require(:new_password_confirmation)
    )
    redirect_to root_url, notice: "Your password has been reset"
  end

end
