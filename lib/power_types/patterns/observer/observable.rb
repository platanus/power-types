module PowerTypes
  module Observable
    @@observable_disabled = false

    def self.observable_disabled=(_value)
      @@observable_disabled = _value
    end

    def self.observable_disabled?
      @@observable_disabled
    end

    def self.included(_klass)
      _klass.extend ClassMethods
    end

    PowerTypes::Util::OBSERVABLE_EVENTS.each do |event|
      define_method("_run_#{event}_callbacks") do |&_block|
        self.class.observers.each { |o| o.trigger(:before, event, self) }
        result = super &_block
        self.class.observers.each { |o| o.trigger(:after, event, self) }
        result
      end
    end

    module ClassMethods
      def observers
        return [] if PowerTypes::Observable.observable_disabled?
        @observers ||= [].tap do |array|
          begin
            array << Kernel.const_get("#{self}Observer")
          rescue NameError
            # could not find observer
          end
        end
      end
    end
  end
end
