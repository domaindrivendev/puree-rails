class Puree::SlimGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :attributes, :type => :array, :default => [], :banner => 'field[:type][:index] field[:type][:index]'

  def create_root_folder
    empty_directory(File.join(view_dir, plural_file_name))
  end

  def create_view_files
    template('index.erb', File.join(view_dir, plural_file_name, 'index.html.slim'))
    template('new.erb', File.join(view_dir, plural_file_name, 'new.html.slim'))
    template('show.erb', File.join(view_dir, plural_file_name, 'show.html.slim'))
  end

  private

    def view_dir
      return @view_dir unless @view_dir.nil?

      namespace_dir = (namespaced?) ? namespaced_class_path : ''
      @view_dir = File.join('app/views', namespace_dir)
    end
end