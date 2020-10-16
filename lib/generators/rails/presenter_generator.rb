module Rails
  class PresenterGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    desc "This generator creates a new presenter at app/presenters"

    def create_presenter
      template('presenter.rb', "app/presenters/#{file_name.underscore}_presenter.rb")
      template('presenter_spec.rb', "spec/presenters/#{file_name.underscore}_presenter_spec.rb")
    end
  end
end
