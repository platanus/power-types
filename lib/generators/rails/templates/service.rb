class <%= class_name %> < Service.new(<%= attributes_names.map { |n| ":#{n}" }.join(', ') %>)
  # Service code goes here
end
