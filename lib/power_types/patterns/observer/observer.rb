module PowerTypes
  class Observer
    include AfterCommitEverywhere

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

    PowerTypes::Util::OBSERVABLE_TRANSACTIONAL_EVENTS.each do |event|
      PowerTypes::Util::OBSERVABLE_TYPES.each do |type|
        next unless type == :after

        method_name = "#{type}_#{event}"
        callback = method_name.gsub('_commit', '')
        define_singleton_method(method_name) do |method|
          send(callback) { execute_method_after_commit(method) }
        end
      end
    end

    def execute_method_after_commit(method)
      after_commit { send(method) }
    end
  end
end
