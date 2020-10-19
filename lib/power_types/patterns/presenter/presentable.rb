module PowerTypes
  module Presentable
    def present_with(presenter_name, data = {})
      presenter_class_by_name(presenter_name).new(view_context, data)
    end

    def presenter_class_by_name(presenter_name)
      class_name = presenter_name.to_s.classify
      class_constant = class_name.safe_constantize

      if class_constant.blank?
        raise PowerTypes::PresenterError.new(
          "missing #{class_name} presenter class"
        )
      end

      class_constant
    end
  end
end
