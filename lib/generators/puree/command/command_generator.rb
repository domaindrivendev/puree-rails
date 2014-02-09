require 'generators/puree/puree_generator_helper'

module Puree
  
  class CommandGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :optional => false, :banner => 'field[:type][:index] field[:type][:index]'

    include PureeGeneratorHelper

    def add_command
      template('command.erb', "#{view_models_path}/#{file_name}.rb")
    end
  end

end