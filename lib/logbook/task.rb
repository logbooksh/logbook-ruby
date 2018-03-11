module Logbook
  class Task
    attr_accessor :entries, :id, :properties, :status, :title, :time_logged

    DONE = "Done"
    PAUSE = "Pause"
    REOPEN = "Reopen"
    RESUME = "Resume"
    START = "Start"
    TASK_ID_PROPERTY = "ID"

    def initialize(id)
      @entries = []
      @id = id
      @properties = {}
      @time_logged = Duration.new(0)
    end

    def add_entry(entry)
      self.properties.merge!(entry.properties)
      self.status = entry.status
      self.title = entry.title
    end

    def log_work(entry, duration)
      add_entry(entry)

      self.time_logged += duration
    end
  end
end
