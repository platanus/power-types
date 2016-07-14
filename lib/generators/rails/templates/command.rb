class <%= class_name %> < Command.new(<%= attributes_names.map { |n| ":#{n}" }.join(', ') %>)
  def perform
    # Command code goes here
  end
end
