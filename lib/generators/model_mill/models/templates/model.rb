class <%= options[:namespace] ? options[:namespace].camelize + '::' : '' %><%= @model_name %> < <%= options[:namespace] ? options[:namespace].camelize : 'ActiveRecord' %>::Base
  attr_accessible <%= @columns.map(&:name).sort.map{|c| ":#{c}"}.join(', ') %>

<% @associations.each do |cardinality, associations|
  -%><% associations.each do |a|
  -%><%= "  #{cardinality} :#{a[:name]}" +
         (options[:namespace] ? ", :class_name => '#{options[:namespace].camelize}::#{a[:name].singularize.camelize}'" : '')
  %>
<% end %><% end %>
end

