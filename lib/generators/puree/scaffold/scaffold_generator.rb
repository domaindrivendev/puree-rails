require 'generators/puree/puree_generator_helper'

module Puree
  class ScaffoldGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :default => [], :banner => 'field[:type][:index] field[:type][:index]'

    include PureeGeneratorHelper

    def create_route
      route("resources :#{plural_file_name}")
    end

    def create_controller 
      template('controller.erb', "#{controllers_path}/#{plural_file_name}_controller.rb")
    end

    def create_aggregate_root
      file_path = "#{domain_path}/#{file_name}.rb"
      template('aggregate_root.erb', file_path)

      prepend_file(domain_module_path, "require_relative 'domain\/#{file_name}'\n")
    end

    def create_repository_accessor
      # method_body = "\ndef #{file_name}_repository\nend\n"
      # inject_into_file(persistence_module_path, method_body, after: 'module Persistence')
    end

    def create_view_model_files
      template('create_form.erb', "#{view_models_path}/create_#{file_name}.rb")
    end

    hook_for :template_engine, :in => :puree

    hook_for :orm, :as => :model do |model|
      short_class_name = class_name.split('::').last
      invoke model, [ short_class_name ].concat(attributes.map { |a| "#{a.name}:#{a.type}" })
    end
  end

end