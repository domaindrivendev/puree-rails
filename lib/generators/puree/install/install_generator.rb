require 'generators/puree/puree_generator_helper'

module Puree

  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    include PureeGeneratorHelper

    def create_domain_module
      empty_directory(domain_path)
      template('domain.erb', domain_module_path)
    end

    def create_integration_module
      empty_directory(integration_path)
      template('integration.erb', integration_module_path)
    end

    def create_persistence_module
      empty_directory(persistence_path)
      template('persistence.erb', persistence_module_path)
    end
  end
end