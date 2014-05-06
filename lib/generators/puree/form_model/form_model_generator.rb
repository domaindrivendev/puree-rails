require 'generators/puree/puree_generator_helper'

module Puree
  
  class FormModelGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :optional => false, :banner => 'field[:type][:index] field[:type][:index]'
    # TODO: class_option :persistent, :type => :boolean, :aliases => %w(-p)

    include PureeGeneratorHelper

    def add_form
      template('transient_form.erb', "#{view_models_path}/#{file_name}_form.rb")
    end
  end

end