module Logbook
  class Page
    attr_accessor :entries, :properties

    def initialize
      @entries = []
    end

    def add(entry)
      entries << entry
    end

    def entry_at(line_number)
      entries.reverse.find { |entry| entry.line_number <= line_number }
    end

    def total_duration
      _, duration = entries.inject([nil, Duration.new(0)]) do |(previous_entry, duration), current_entry|
        if previous_entry && previous_entry.starts_clock?
          if current_entry.stops_clock?
            new_duration = Duration.new(duration.minutes + minutes_in_between(previous_entry, current_entry))
            [current_entry, new_duration]
          else
            [previous_entry, duration]
          end
        else
          [current_entry, duration]
        end
      end

      duration
    end

    private
    def minutes_in_between(previous_entry, current_entry)
      (current_entry.recorded_at.to_time - previous_entry.recorded_at.to_time) / 60
    end
  end
end
