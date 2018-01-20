module Logbook
  class TaskEntry < Struct.new(:line_number, :time, :title, :status, :properties, :tags, :note)
    def merge_page_properties(properties)
      self.properties = properties.merge(self.properties)
    end
  end
end
