require 'generators/puree/puree_generator_helper'

module Puree
  
  class ValueObjectGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :optional => false, :banner => 'field[:type][:index] field[:type][:index]'

    include PureeGeneratorHelper

    def add_value_object
      file_path = "#{domain_path}/#{file_name}.rb"
      template('value_object.erb', file_path)

      prepend_file(domain_module_path, "require_relative 'domain\/#{file_name}'\n")
    end
  end

end