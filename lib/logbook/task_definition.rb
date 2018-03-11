module Logbook
  class TaskDefinition < Struct.new(:line_number, :title, :status, :properties, :note)
    def belongs_to_task?
      self.properties.has_key?(Task::TASK_ID_PROPERTY) &&
        self.properties[Task::TASK_ID_PROPERTY].has_value?
    end

    def merge_page_properties(properties)
      self.properties = properties.merge(self.properties)
    end

    def task_id
      self.properties[Task::TASK_ID_PROPERTY].value
    end
  end
end
