require "date"

module Logbook
  class TaskEntry < Struct.new(:line_number, :time, :title, :status, :properties, :note)
    DATE_PROPERTY_NAME = "Date"

    def belongs_to_task?
      self.properties.has_key?(Task::TASK_ID_PROPERTY) &&
        self.properties[Task::TASK_ID_PROPERTY].has_value?
    end

    def merge_page_properties(properties)
      self.properties = properties.merge(self.properties)
    end

    def recorded_at
      date = self.properties[DATE_PROPERTY_NAME].value
      time = self.time

      DateTime.parse(date + " " + time)
    rescue ArgumentError
    end

    def starts_clock?
      [Task::START, Task::RESUME, Task::REOPEN].include?(self.status)
    end

    def task_id
      self.properties[Task::TASK_ID_PROPERTY].value
    end
  end
end
