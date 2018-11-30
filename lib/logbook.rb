module Logbook
  VERSION = "0.1.5"

  require "logbook/builder"
  require "logbook/clock"
  require "logbook/task_entry"
  require "logbook/log_entry"
  require "logbook/task_definition"
  require "logbook/task"
  require "logbook/page"
  require "logbook/parser"
  require "logbook/property"

  Duration = Struct.new(:minutes) do
    def +(other_duration)
      Duration.new(self.minutes + other_duration.minutes)
    end
  end

  Tag = Struct.new(:label)
end
