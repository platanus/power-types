module PowerTypes
  class BasePresenter
    def initialize(view, params = {})
      @h = view

      params.each_pair do |attribute, value|
        if respond_to?(attribute, true)
          raise PowerTypes::PresenterError.new(
            "attribute #{attribute} already defined in presenter"
          )
        end

        singleton_class.send(:attr_accessor, attribute)
        instance_variable_set("@#{attribute}", decorated_value(value))
      end
    end

    private

    attr_reader :h

    def decorated_value(value)
      value.decorate
    rescue NameError
      value
    end
  end
end
