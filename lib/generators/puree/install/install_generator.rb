require 'generators/puree/puree_generator_helper'

module Puree

  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    include PureeGeneratorHelper

    def create_listeners_dir
      empty_directory(listeners_path)
    end

    def add_initializer
      template('initializer.erb', "config/initializers/puree-rails.rb")
    end

    def create_domain_module
      empty_directory(domain_path)
      template('domain.erb', domain_module_path)
    end

    def create_persistence_module
      template('persistence.erb', persistence_module_path)
    end

    def add_base_command
      template('command.erb', "#{view_models_path}/command.rb")
    end

    def copy_event_store_migrations
      copy_file('20131201000000_create_event_streams.rb', 'db/migrate/20131201000000_create_event_streams.rb')  
      copy_file('20131201000001_create_event_records.rb', 'db/migrate/20131201000001_create_event_records.rb')
    end

    def copy_id_generator_migrations
      copy_file('20131201000002_create_id_counters.rb', 'db/migrate/20131201000002_create_id_counters.rb') 
    end
  end
end