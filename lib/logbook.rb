module Logbook
  VERSION = "0.1.4"

  require "logbook/builder"
  require "logbook/clock"
  require "logbook/log_entry"
  require "logbook/page"
  require "logbook/parser"
  require "logbook/property"
  require "logbook/task"
  require "logbook/task_definition"
  require "logbook/task_entry"

  Duration = Struct.new(:minutes) do
    def +(other_duration)
      Duration.new(self.minutes + other_duration.minutes)
    end
  end
end
