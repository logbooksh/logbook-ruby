module Logbook
  class Clock
    def tick(entry)
      case entry
      when LogEntry
        if running?
          yield(tracked_entry, minutes_in_between(tracked_entry, entry))
          reset
        end
      when TaskEntry
        if running?
          yield(tracked_entry, minutes_in_between(tracked_entry, entry))
          reset
        end

        if entry.starts_clock?
          track(entry)
        end
      else
        # ignore
      end
    end

    private
    attr_accessor :tracked_entry

    def reset
      @tracked_entry = nil
    end

    def running?
      !tracked_entry.nil?
    end

    def track(entry)
      @tracked_entry = entry
    end

    def minutes_in_between(previous_entry, current_entry)
      Duration.new((current_entry.recorded_at.to_time - previous_entry.recorded_at.to_time) / 60)
    end
  end
end
