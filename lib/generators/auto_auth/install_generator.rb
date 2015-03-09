require 'rails/generators/base'

module AutoAuth
  class InstallGenerator < Rails::Generators::Base

    include Rails::Generators::Migration

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), "..", "templates"))
    end

    def self.next_migration_number(dirname) #:nodoc:
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    desc "Install base authentication strategy into app ready to be customized"

    class_option :domain_model, :type => :string, :default => 'user', :desc => 'Domain resource for users of the system (e.g user, admin, student etc)'
    class_option :identity_model, :type => :string, :default => 'identity', :desc => 'Login credentials owned by a user (e.g login, credential, identity etc)'

    def add_gems
      gem "bcrypt"
      gem "responders"
    end

    def create_model_files
      template "models/domain_model.rb", "app/models/#{domain_model}.rb"
      template "models/identity_model.rb", "app/models/#{identity_model}.rb"
      template "models/registration.rb", "app/models/registration.rb"
      template "models/concerns/token_verification.rb", "app/models/concerns/token_verification.rb"
    end

    def create_controller_files
      template "controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
      template "controllers/passwords_controller.rb", "app/controllers/passwords_controller.rb"
      template "controllers/registrations_controller.rb", "app/controllers/registrations_controller.rb"
    end

    def create_mailer_files
      template "mailers/identity_mailer.rb", "app/mailers/#{identity_model}_mailer.rb"

      template "views/mailers/reset_password.html.erb", "app/views/#{identity_model}_mailer/reset_password.html.erb"
      template "views/mailers/confirm_email.html.erb", "app/views/#{identity_model}_mailer/confirm_email.html.erb"
    end

    def create_routes
      route <<-REGISTRATION_ROUTE
resources :registrations, only: [:create] do
    get :confirm, on: :collection
  end
      REGISTRATION_ROUTE
      route "resources :passwords, only: [:edit, :create, :update]"
      route "resources :sessions, only: [:create]"
      route "get :forgot_password, to: 'passwords#new'"
      route "get :sign_up, to: 'registrations#new'"
      route "get :sign_out, to: 'sessions#destroy'"
      route "get :sign_in, to: 'sessions#new'"
    end

    def create_migration_files
      migration_template "migration.rb", "db/migrate/create_#{domain_model}_and_#{identity_model}.rb"
    end

    def include_authentication
      template "controllers/concerns/authentication.rb", "app/controllers/concerns/authentication.rb"
      inject_into_file "app/controllers/application_controller.rb", after: /protect_from_forgery.*$/ do
      <<-AUTOAUTH


  include Authentication

  before_action :authenticate!

  rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :handle_invalid_signature


  private

  def handle_invalid_signature
    redirect_to(root_path, alert: t(:'auto_auth.application.invalid_signature'))
  end
      AUTOAUTH
      end
    end

    def create_view_files
      template "views/sessions/new.html.erb", "app/views/sessions/new.html.erb"

      template "views/passwords/new.html.erb", "app/views/passwords/new.html.erb"
      template "views/passwords/edit.html.erb", "app/views/passwords/edit.html.erb"

      template "views/registrations/new.html.erb", "app/views/registrations/new.html.erb"

      template "config/locales/auto_auth.en.yml", "config/locales/auto_auth.en.yml"
    end


    private

    # Domain model helpers
    #
    def domain_model
      @domain_model ||= options.domain_model.underscore
    end

    def domain_model_class
      @domain_model_class ||= domain_model.classify
    end

    def domain_model_id
      @domain_model_id ||= "#{domain_model}_id"
    end

    def plural_domain_model
      @plural_domain_model ||= domain_model.pluralize
    end


    # Identity Model Helpers
    #
    def identity_model
      @identity_model ||= options.identity_model.underscore
    end

    def identity_model_class
      @identity_model_class ||= identity_model.classify
    end

    def plural_identity_model
      @plural_identity_model ||= identity_model.pluralize
    end

    def identity_mailer_class
      @identity_mailer_class ||= "#{identity_model_class}Mailer".classify
    end


  end
end
