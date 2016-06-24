module PowerTypes
  module Command
    # rubocop:disable Metrics/MethodLength
    def self.new(*_attributes)
      attr_names = []
      attr_defaults = {}

      _attributes.each do |att|
        if att.is_a? Hash
          attr_defaults.merge! att
          attr_names += att.keys
        else
          attr_names << att
        end
      end

      Class.new do
        def self.for(kwargs = {})
          new(kwargs).perform
        end

        def logger
          Rails.logger
        end

        def perform
          raise NotImplementedError, "Command must implement `perform`"
        end

        define_method(:initialize) do |kwargs = {}|
          unless (kwargs.keys - attr_names).empty?
            raise ArgumentError, "Unexpected arguments: #{(kwargs.keys - attr_names).join(', ')}"
          end

          kwargs = attr_defaults.merge kwargs
          attr_names.map do |a|
            raise ArgumentError, "Missing parameter: #{a}" unless kwargs.key? a
            instance_variable_set "@#{a}", kwargs[a]
          end
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
