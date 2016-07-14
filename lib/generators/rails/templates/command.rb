class <%= class_name %> < PowerTypes::Command.new(<%= attributes_names.map { |n| ":#{n}" }.join(', ') %>)
  def perform
    # Command code goes here
  end
end
