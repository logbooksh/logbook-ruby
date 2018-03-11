module Logbook
  class Page
    attr_accessor :clock, :entries, :logged_work, :properties

    def initialize
      @clock = Clock.new
      @entries = []
      @logged_work = {}
    end

    def add(entry)
      entries << entry
      clock.tick(entry) { |tracked_entry, duration| logged_work.store(tracked_entry, duration) }
    end

    def entry_at(line_number)
      entries.reverse.find { |entry| entry.line_number <= line_number }
    end

    def logged_time
      logged_work.map { |entry, duration| duration }.reduce(Duration.new(0), &:+)
    end

    def tasks
      entries.reduce({}) do |tasks, entry|
        case entry
        when TaskEntry, TaskDefinition
          if entry.belongs_to_task?
            task = tasks[entry.task_id] ||= Task.new(entry.task_id)

            if logged_work.has_key?(entry)
              task.log_work(entry, logged_work[entry])
            else
              task.add_entry(entry)
            end
          end
        else
        end

        tasks
      end
    end
  end
end
