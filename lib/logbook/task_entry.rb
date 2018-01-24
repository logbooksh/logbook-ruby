require "date"

module Logbook
  class TaskEntry < Struct.new(:line_number, :time, :title, :status, :properties, :tags, :note)
    DATE_PROPERTY_NAME = "Date"

    def merge_page_properties(properties)
      self.properties = properties.merge(self.properties)
    end

    def recorded_at
      date = self.properties[DATE_PROPERTY_NAME]
      time = self.time

      DateTime.parse(date + " " + time)
    rescue ArgumentError
    end

    def starts_clock?
      [Task::START, Task::RESUME, Task::REOPEN].include?(self.status)
    end

    def stops_clock?
      true
    end
  end
end
