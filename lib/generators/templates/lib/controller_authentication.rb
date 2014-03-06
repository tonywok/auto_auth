module ControllerAuthentication

  extend ActiveSupport::Concern

  included do
    helper_method :current_<%= domain_model %>, :signed_in?, :redirect_to_or_default
  end

  def current_<%= domain_model %>
    if session[:<%= domain_model %>_id].present?
      @current_<%= domain_model %> ||= <%= domain_model_class %>.find(session[:<%= domain_model %>_id])
    end
  end

  def signed_in?
    !!current_<%= domain_model %>
  end

  def authenticate!
    unless signed_in?
      store_target_location
      redirect_to sign_in_url, alert: "You must be signed in to perform that action"
    end
  end

  def redirect_to_target_or_default(default, *args)
    redirect_to(session[:return_to] || default, *args)
    session[:return_to] = nil
  end


  private

  def store_target_location
    session[:return_to] = request.url
  end

end
