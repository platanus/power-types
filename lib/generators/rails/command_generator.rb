module Rails
  class CommandGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    argument :attributes, type: :array, default: [], banner: "field field"

    desc "This generator creates a new command at app/commands"
    def create_command
      template('command.rb', "app/commands/#{file_name.underscore}.rb")
      template('command_spec.rb', "specs/commands/#{file_name.underscore}_spec.rb")
    end
  end
end
