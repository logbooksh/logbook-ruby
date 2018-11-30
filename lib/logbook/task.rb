module Logbook
  class Task
    attr_accessor :entries, :id, :properties, :tags, :title, :logged_time

    class Status
      TODO = "Todo"
      ONGOING = "Ongoing"
      DONE = "Done"
    end

    ENTRY_STATUS_TO_TASK_STATUS = {
      TaskEntry::Status::TODO => Status::TODO,
      TaskEntry::Status::START => Status::ONGOING,
      TaskEntry::Status::PAUSE => Status::ONGOING,
      TaskEntry::Status::RESUME => Status::ONGOING,
      TaskEntry::Status::REOPEN => Status::ONGOING,
      TaskEntry::Status::DONE => Status::DONE,
    }

    TASK_ID_PROPERTY = "ID"

    def initialize(id)
      @entries = []
      @id = id
      @properties = {}
      @tags = Set.new
      @logged_time = Duration.new(0)
    end

    def add_entry(entry)
      self.properties.merge!(entry.properties)
      self.tags.merge(entry.tags)
      self.title = entry.title
      self.entries.push(entry)
    end

    def log_work(entry, duration)
      add_entry(entry)

      self.logged_time += duration
    end

    def status
      most_recent_entry =
        self.entries.select { |entry| entry.instance_of?(TaskEntry) }.
        sort_by(&:recorded_at).last

      if most_recent_entry.nil?
        Status::TODO
      else
        ENTRY_STATUS_TO_TASK_STATUS.fetch(most_recent_entry.status)
      end
    end
  end
end
