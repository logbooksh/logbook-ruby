module Logbook
  class Page
    attr_accessor :entries, :properties

    def initialize
      @entries = []
    end

    def add(entry)
      entries.unshift(entry)
    end

    def entry_at(line_number)
      entries.find { |entry| entry.line_number <= line_number }
    end
  end
end
