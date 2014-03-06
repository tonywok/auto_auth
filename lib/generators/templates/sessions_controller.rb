class SessionsController < ApplicationController

  skip_before_filter :authenticate, only: :new

  def new
    redirect_to after_login_path, alert: "You're already logged in" if signed_in?
  end

  def create
    identity = <%= domain_model.classify %>.find_by(email: params.require(:email))
    if identity && identity.authenticate(params.require(:password))
      session[:<%= "#{domain_model.underscore}_id" %>] = identity.<%= "#{domain_model.underscore}_id" %>
      redirect_to after_sign_in_path, alert: "Successfully logged in"
    else
      redirect_to sign_in_path, alert: "Incorrect email/password"
    end
  end

  def destroy
    reset_session
    redirect_to sign_in_path, alert: "Successfully signed out"
  end


  private

  def after_sign_in_path
    root_path
  end

end
