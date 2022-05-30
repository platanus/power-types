class <%= class_name %>Util < PowerTypes::BaseUtil
<% attributes_names.each do |method_name| %>
  def self.<%= method_name %>
    # Method code goes here
  end
<% end %>
end
