module Rails
  class ServiceGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    argument :attributes, type: :array, default: [], banner: "field field"

    desc "This generator creates a new service at app/services"
    def create_service
      return puts "Service name must end with 'Service'" unless class_name.ends_with? "Service"
      template('service.rb', "app/services/#{file_name.underscore}.rb")
      template('service_spec.rb', "specs/services/#{file_name.underscore}_spec.rb")
    end
  end
end
