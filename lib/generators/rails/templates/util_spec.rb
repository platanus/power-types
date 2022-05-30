require 'rails_helper'

describe <%= class_name %>Util do
<% attributes_names.each do |method_name| %>
  describe '#<%= method_name %>' do
    pending 'describe what the util method <%= method_name %> does here'
  end
<% end %>
end
