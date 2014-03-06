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
      gem "bcrypt-ruby", "~> 3.1.2"
    end

    def create_model_files
      template "domain_model.rb", "app/models/#{domain_model}.rb"
      template "identity_model.rb", "app/models/#{identity_model}.rb"
    end

    def create_controller_files
      template "sessions_controller.rb", "app/controllers/sessions_controller.rb"
      template "passwords_controller.rb", "app/controllers/sessions_controller.rb"
    end

    def create_lib_files
      template "controller_authentication.rb", "lib/controller_authentication.rb"
    end

    def create_routes
      route "resources :sessions, only: [:create]"
      route "get :sign_in, to: 'sessions#new'"
      route "get :sign_out, to: 'sessions#destroy'"
    end

    def create_migration_files
      migration_template "migration.rb", "db/migrate/create_#{domain_model}_and_#{identity_model}.rb"
    end

    def include_authentication
      inject_into_class "app/controllers/application_controller.rb", "ApplicationController", "  include ControllerAuthentication\n"
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

  end
end
