module PowerTypes
  class BaseUtil
    def initialize
      raise PowerTypes::UtilError.new('a util cannot be instantiated')
    end
  end
end
