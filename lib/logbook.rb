module Logbook
  VERSION = "0.1.3"

  require "logbook/builder"
  require "logbook/page"
  require "logbook/parser"
  require "logbook/task_definition"
  require "logbook/task_entry"

  Property = Struct.new(:name, :value)
  Tag = Struct.new(:value)

  LogEntry = Struct.new(:line_number, :time, :note)
end
