module PureeGeneratorHelper

  def controllers_path
    @controllers_path ||= File.join('app/controllers', namespace_file_name)
  end

  def view_models_path
    @view_models_path ||= File.join('app/models', namespace_file_name)
  end

  def listeners_path
    @listeners_path ||= File.join('app/listeners', namespace_file_name)
  end

  def domain_path
    @domain_path ||= File.join('lib', namespace_file_name, 'domain')
  end

  def domain_module_path
    "#{domain_path}.rb"
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