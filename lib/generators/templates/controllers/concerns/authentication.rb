require 'active_support/concern'

module Authentication

  extend ActiveSupport::Concern

  included do
    helper_method :current_<%= domain_model %>, :signed_in?, :redirect_to_or_default
  end

  def sign_in!(<%= domain_model %>)
    session[:<%= domain_model %>_id] = <%= domain_model %>.id
  end

  def current_<%= domain_model %>
    if session[:<%= domain_model %>_id].present?
      @current_<%= domain_model %> ||= <%= domain_model_class %>.find(session[:<%= domain_model %>_id])
    end
  rescue ActiveRecord::RecordNotFound => e
    reset_session
  end

  def signed_in?
    !!current_<%= domain_model %>
  end

  def authenticate!
    unless signed_in?
      store_target_location
      redirect_to(sign_in_url, alert: t(:"auto_auth.sessions.required"))
    end
  end

  def redirect_to_target_or_default(default, *args)
    redirect_to(session[:return_to] || default, *args)
    session[:return_to] = nil
  end

  def redirect_authenticated
    if signed_in?
      redirect_to_target_or_default(root_path, notice: t(:"auto_auth.sessions.existing"))
    end
  end


  private

  def store_target_location
    session[:return_to] = request.url
  end

end
