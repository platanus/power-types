module PowerTypes
  class Trigger
    attr_reader :type, :event

    def initialize(_type, _event, _handler = nil, _options = {}, &_block)
      validate_params(_type, _event, _handler, _block)
      @type = _type
      @event = _event
      @handler = _handler || _block
      @options = _options
    end

    def call(_observer)
      case @handler
      when String, Symbol
        _observer.public_send(@handler)
      when Proc
        _observer.instance_exec(&@handler)
      end
    end

    private

    def validate_params(_type, _event, _handler, _block)
      raise "Invalid type #{_type}" unless PowerTypes::Util::OBSERVABLE_TYPES.include?(_type)
      raise "Invalid event #{_event}" unless PowerTypes::Util::OBSERVABLE_EVENTS.include?(_event)
      raise "Invalid handler" unless [String, Symbol, NilClass, Proc].include?(_handler.class)
      raise "Missing block or handler name" if !_handler && !_block
    end
  end
end
