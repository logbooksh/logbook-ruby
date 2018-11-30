require "date"

module Logbook
  class TaskEntry
    attr_accessor :line_number, :note, :properties, :status, :tags, :time, :title

    DATE_PROPERTY_NAME = "Date"

    class Status
      TODO = "Todo"
      DONE = "Done"
      PAUSE = "Pause"
      REOPEN = "Reopen"
      RESUME = "Resume"
      START = "Start"
    end

    def initialize(time:, line_number: 1, title: "", status: Status::TODO, properties: {}, tags: Set.new, note: "")
      @line_number = line_number
      @time = time
      @title = title
      @status = status
      @properties = properties
      @tags = tags
      @note = note
    end

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
      [Status::START, Status::RESUME, Status::REOPEN].include?(self.status)
    end

    def task_id
      self.properties[Task::TASK_ID_PROPERTY].value
    end
  end
end
