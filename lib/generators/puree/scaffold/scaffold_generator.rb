require 'generators/puree/puree_generator_helper'

module Puree
  
  class ScaffoldGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :default => ['id:integer'], :banner => 'field[:type][:index] field[:type][:index]'

    include PureeGeneratorHelper

    def add_route
      route("resources :#{plural_file_name}")
    end

    def add_controller 
      template('controller.erb', "#{controllers_path}/#{plural_file_name}_controller.rb")
    end

    def add_aggregate
      file_path = "#{domain_path}/#{file_name}.rb"
      template('aggregate_root.erb', file_path)

      prepend_file(domain_module_path, "require_relative 'domain\/#{file_name}'\n")
    end

    def add_repository
      indent = namespace.nil? ? "\t" : "\t\t"
      inject_into_file(persistence_module_path, after: "module Persistence\n") do <<-EOT.gsub(/^      /, indent)

      def #{file_name}_repository
        @#{file_name}_repository ||= Puree::Repository.for(
          Domain::#{class_name.split('::').last},
          id_generator,
          event_store,
          event_dispatcher)
      end
      EOT
      end
    end

    def add_form
      template('transient_form.erb', "#{view_models_path}/new_#{file_name}_form.rb")
    end

    def add_denormalizer
      template('denormalizer.erb', "#{listeners_path}/#{file_name}_denormalizer.rb")
    end

    hook_for :template_engine, :in => :puree

    hook_for :orm, :as => :model do |model|
      short_class_name = class_name.split('::').last
      invoke model, [ short_class_name ].concat(attributes.map { |a| "#{a.name}:#{a.type}" })
    end
  end

end