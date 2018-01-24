module Logbook
  class LogEntry < Struct.new(:line_number, :time, :note)
    DATE_PROPERTY_NAME = "Date"

    attr_accessor :properties

    def recorded_at
      date = self.properties[DATE_PROPERTY_NAME]
      time = self.time

      DateTime.parse(date + " " + time)
    rescue ArgumentError
    end

    def starts_clock?
      false
    end

    def stops_clock?
      true
    end
  end
end
