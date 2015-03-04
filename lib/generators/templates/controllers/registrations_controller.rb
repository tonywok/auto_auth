class RegistrationsController < ApplicationController

  respond_to :html

  skip_before_action :authenticate!, only: [:new, :confirm, :create]
  before_action :redirect_authenticated, only: [:new, :create]
  before_action :setup_<%= identity_model %>, only: [:confirm]

  def new
    @registration = Registration.new
  end

  def confirm
    @<%= identity_model %>.confirm!
    redirect_to(root_path, notice: t(:'auto_auth.registration.confirmed'))
  end

  def create
    @registration = Registration.new(registration_params)
    if <%= domain_model %> = @registration.save!
      sign_in!(<%= domain_model %>)
      <%= domain_model %>.<%= identity_model %>.send_confirmation_email
      redirect_to(root_path, notice: t(:'auto_auth.registrations.account_created'))
    else
      render :new
    end
  end


  private

  def setup_<%= identity_model %>
    <%= identity_model_class %>.verify_signature!(<%= identity_model_class %>::EMAIL_CONFIRMATION_KEY, params.require(:email_confirmation_token)) do |record, expires_at|
      if expires_at < Time.current
        redirect_to(root_path, alert: t(:'auto_auth.registrations.expired'))
      else
        @<%= identity_model %> = record
      end
    end
  end

  def registration_params
    params.require(:registration).permit(:name, :email, :password, :password_confirmation)
  end

end
