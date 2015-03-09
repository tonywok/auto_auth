class PasswordsController < ApplicationController

  respond_to :html

  skip_before_action :authenticate!
  before_action :setup_<%= identity_model %>, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
    email = params[:<%= identity_model %>][:email]
    if <%= identity_model %> = <%= identity_model_class %>.find_by(email: email)
      <%= identity_mailer_class %>.reset_password(<%= identity_model %>).deliver
    end
    redirect_to(root_path, notice: t(:'auto_auth.passwords.reset_instructions'))
  end

  def update
    if @<%= identity_model %>.update!(password_params)
      redirect_to(root_path, notice: t(:'auto_auth.passwords.reset'))
    else
      render :edit
    end
  end


  private

  def setup_<%= identity_model %>
    <%= identity_model_class %>.verify_signature!(TokenVerification::PASSWORD_RESET, params.require(:password_reset_token)) do |record, expires_at|
      if expires_at < Time.current
        redirect_to(root_path, alert: t(:"auto_auth.passwords.expired")) and return
      else
        @<%= identity_model %> = record
      end
    end
  end

  def password_params
    params.require(:<%= identity_model %>).permit(:password, :password_confirmation)
  end

end
