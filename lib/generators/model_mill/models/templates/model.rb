class <%= namespace ? namespace.camelize + '::' : '' %><%= @model_name %> < <%= namespace ? namespace.camelize : 'ActiveRecord' %>::Base
end

