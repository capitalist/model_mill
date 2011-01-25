class <%= options[:namespace] ? options[:namespace].camelize + '::' : '' %><%= @model_name %> < <%= options[:namespace] ? options[:namespace].camelize : 'ActiveRecord' %>::Base
  attr_accessible <%= @columns.map(&:name).sort.map{|c| ":#{c}"}.join(', ') %>
end

