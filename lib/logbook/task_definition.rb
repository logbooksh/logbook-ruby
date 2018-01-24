module Logbook
  class TaskDefinition < Struct.new(:line_number, :title, :status, :properties, :tags, :note)
    def merge_page_properties(properties)
      self.properties = properties.merge(self.properties)
    end

    def starts_clock?
      false
    end

    def stops_clock?
      false
    end
  end
end
