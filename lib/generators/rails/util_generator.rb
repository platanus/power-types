module Rails
  class UtilGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    argument :attributes, type: :array, default: [], banner: 'method method'

    desc 'This generator creates a new util at app/utils'

    def create_util
      template('util.rb', "app/utils/#{file_name.underscore}_util.rb")
      template('util_spec.rb', "spec/utils/#{file_name.underscore}_util_spec.rb")
    end
  end
end
