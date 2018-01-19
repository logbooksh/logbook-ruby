require "parslet"

module Logbook
  class Parser < Parslet::Parser
    rule(:space) { match["\t "] }
    rule(:whitespace) { space.repeat }
    rule(:newline) { match("\n") }

    rule(:text) { match("[^\n]") }
    rule(:text_line) { text.repeat(0) >> newline }
    rule(:label) { match["a-zA-Z"] >> match["[:word:]"].repeat }

    rule(:property_value) { match("[^\\n\\]\\[]").repeat(1) }
    rule(:property) { whitespace >> str("[") >> label.as(:name) >> str(":") >> whitespace >> property_value.as(:value) >> str("]") >> whitespace >> newline.maybe }
    rule(:property_list) do
      property.repeat
    end

    rule(:time) { str("[") >> (match["0-9"].repeat(2, 2) >> str(":") >> match["0-9"].repeat(2, 2)).as(:time) >> str("]") }
    rule(:status) { str("[") >> label.as(:status) >> str("]") }
    rule(:title) { text.repeat }

    rule(:note_line) { time.absent? >> status.absent? >> text_line }
    rule(:note) { note_line.repeat }

    rule(:log_entry) { time >> whitespace >> newline.maybe >> note.as(:note) }

    rule(:task_definition) do
      status >> whitespace >> title.as(:title) >> str("\n") >>
        newline.repeat >>
        property_list.as(:properties) >>
        newline.repeat >>
        note.as(:note)
    end

    rule(:task_entry) do
      time >> whitespace >> status >> whitespace >> title.as(:title) >> str("\n") >>
        newline.repeat >>
        property_list.maybe.as(:properties) >>
        newline.repeat >>
        note.as(:note)
    end

    rule(:logbook) do
      (
        task_definition.as(:task_definition) |
        task_entry.as(:task_entry) |
        log_entry.as(:log_entry) |
        property.as(:property) |
        text_line
      ).repeat
    end

    root :logbook
  end
end
