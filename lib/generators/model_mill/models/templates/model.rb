class <%= options[:namespace] ? options[:namespace].camelize + '::' : '' %><%= @model_name %> < <%= options[:namespace] ? options[:namespace].camelize : 'ActiveRecord' %>::Base
end

