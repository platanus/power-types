module PowerTypes
  module Command
    def self.new(*_attributes)
      Service.new(*_attributes).tap do |klass|
        klass.class_eval do
          def self.for(kwargs = {})
            new(kwargs).perform
          end

          def perform
            raise NotImplementedError, "Command must implement `perform`"
          end
        end
      end
    end
  end
end
