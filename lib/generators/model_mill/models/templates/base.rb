class <%= namespace.camelize %>::Base < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "<%= namespace %>"
end

