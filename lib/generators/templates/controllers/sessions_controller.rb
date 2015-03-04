class SessionsController < ApplicationController

  skip_before_action :authenticate!, only: [:new, :create]
  before_action :redirect_authenticated, only: [:new]

  def new
  end

  def create
    <%= identity_model %> = <%= identity_model.classify %>.find_by(email: params[:session][:email])
    if <%= identity_model %> && <%= identity_model %>.authenticate(params[:session].delete(:password))
      session[:<%= "#{domain_model.underscore}_id" %>] = <%= identity_model %>.<%= "#{domain_model.underscore}_id" %>
      redirect_to(after_sign_in_path, notice: t(:'auto_auth.sessions.signed_in'))
    else
      flash.now[:alert] = t(:'auto_auth.sessions.bad_combination')
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to(sign_in_path, alert: t(:'auto_auth.sessions.signed_out'))
  end


  private

  def after_sign_in_path
    root_path
  end

end
