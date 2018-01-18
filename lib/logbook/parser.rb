require "parslet"

module Logbook
  class Parser < Parslet::Parser
    VERSION = "0.1.0"

    rule(:space) { match["\t "] }
    rule(:whitespace) { space.repeat }

    rule(:property_name) { match["a-zA-Z"] >> match["[:word:]"].repeat }
    rule(:property_value) { match["[:word:]"].repeat(1) }
    rule(:property) { str("[") >> property_name.as(:name) >> str(":") >> whitespace >> property_value.as(:value) >> str("]") }

    rule(:time) { str("[") >> (match["0-9"].repeat(2, 2) >> str(":") >> match["0-9"].repeat(2, 2)).as(:time) >> str("]") }
    rule(:note_line) { time.absent? >> match("\w").repeat >> str("\n") }
    rule(:text_line) { time.absent? >> (str("\n").absent? >> any).repeat >> str("\n") }
    rule(:note) { text_line.repeat }

    rule(:log_entry) { time >> whitespace >> str("\n") >> note.as(:note) }

    rule(:logbook) { (log_entry.as(:log_entry) | property.as(:property) | text_line).repeat }

    root :logbook
  end
end
