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
  end
end
