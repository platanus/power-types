module PowerTypes
  class Observer
    attr_reader :object

    PowerTypes::Util::OBSERVABLE_EVENTS.each do |event|
      PowerTypes::Util::OBSERVABLE_TYPES.each do |type|
        define_singleton_method("#{type}_#{event}") do |args = nil, &_block|
          add_trigger(type, event, *args, &_block)
        end
      end
    end

    def self.trigger(_type, _event, _object)
      triggers.select { |t| t.type == _type && t.event == _event }.each do |trigger|
        trigger.call(new(_object))
      end
    end

    def self.add_trigger(_type, _event, _handler = nil, _options = {}, &_block)
      triggers << PowerTypes::Trigger.new(
        _type,
        _event,
        (_handler || _block),
        _options
      )

      triggers.last
    end

    def self.triggers
      @triggers ||= []
    end

    def initialize(_object)
      @object = _object
    end
  end
end
