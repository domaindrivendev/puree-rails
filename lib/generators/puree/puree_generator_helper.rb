module PureeGeneratorHelper

  def controllers_path
    @controllers_path ||= File.join('app/controllers', namespace_file_name)
  end

  def view_models_path
    @view_models_path ||= File.join('app/models', namespace_file_name)
  end

  def domain_path
    @domain_path ||= File.join('lib', namespace_file_name, 'domain')
  end

  def domain_module_path
    "#{domain_path}.rb"
  end

  def integration_path
    @integration_path ||= File.join('lib', namespace_file_name, 'integration')
  end

  def integration_module_path
    "#{integration_path}.rb"
  end

  def persistence_path
    @persistence_path ||= File.join('lib', namespace_file_name, 'persistence')
  end

  def persistence_module_path
    "#{persistence_path}.rb"
  end

  def namespace
    Rails::Generators.namespace
  end

  def namespace_class_name
    @namespace_class_name ||= (namespace ? namespace.name : '')
  end

  def namespace_file_name
    @namespace_file_name ||= namespace_class_name.underscore
  end
end