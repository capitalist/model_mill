class <%= options[:namespace].camelize %>::Base < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "<%= options[:namespace] %>"
end

