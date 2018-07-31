module Rails
  class ObserverGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    desc "This generator creates a new observer at app/observers"
    def create_observer
      template('observer.rb', "app/observers/#{file_name.underscore}_observer.rb")
      template('observer_spec.rb', "spec/observers/#{file_name.underscore}_observer_spec.rb")
    end

    def include_observable_mixin
      line = "class #{class_name} < #{active_record_klass}"
      gsub_file "app/models/#{file_name.underscore}.rb", /(#{Regexp.escape(line)})/mi do |match|
        "#{match}\n  include PowerTypes::Observable"
      end
    end

    private

    def active_record_klass
      if ::Rails::VERSION::MAJOR > 4
        ApplicationRecord
      else
        ActiveRecord::Base
      end
    end
  end
end
