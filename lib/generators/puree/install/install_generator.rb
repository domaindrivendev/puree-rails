require 'generators/puree/puree_generator_helper'

module Puree

  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    include PureeGeneratorHelper

    def create_domain_module
      empty_directory(domain_path)
      template('domain.erb', domain_module_path)
    end

    def create_persistence_module
      empty_directory(persistence_path)
      template('persistence.erb', persistence_module_path)
    end

    def copy_event_store_migrations
      copy_file('20131201000000_create_event_streams.rb', 'db/migrate/20131201000000_create_event_streams.rb')  
      copy_file('20131201000001_create_event_records.rb', 'db/migrate/20131201000001_create_event_records.rb')
    end
  end
end