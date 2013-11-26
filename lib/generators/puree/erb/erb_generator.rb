class Puree::ErbGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def test
    raise 'Eureka!'
  end
end
