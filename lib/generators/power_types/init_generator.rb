module PowerTypes
  class InitGenerator < Rails::Generators::Base
    desc "This generator creates the folder structure for the power-types gem"

    def create_folders
      empty_directory "app/commands/"
      empty_directory "app/services/"
      empty_directory "app/observers/"
      empty_directory "app/presenters/"
      empty_directory "app/utils/"
      empty_directory "app/values/"
    end

    def config_presenters
      insert_into_file(
        "app/controllers/application_controller.rb",
        "\n  include PowerTypes::Presentable",
        after: "ActionController::Base"
      )
    end
  end
end
