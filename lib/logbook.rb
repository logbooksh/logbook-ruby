module Logbook
  VERSION = "0.1.3"

  require "logbook/builder"
  require "logbook/page"
  require "logbook/parser"
  require "logbook/log_entry"
  require "logbook/task"
  require "logbook/task_definition"
  require "logbook/task_entry"

  Duration = Struct.new(:minutes)
  Property = Struct.new(:name, :value)
  Tag = Struct.new(:value)
end
