require "spec_helper"
require "parslet/convenience"

RSpec.describe Logbook::Parser do
  it "parses properties" do
    expected_properties = [{property: {name: "Name", value: "Value"}}]
    expect(Logbook::Parser.new.parse("[Name: Value]")).to eq(expected_properties)
  end

  it "parses log entries" do
    logbook = <<~LOG
    [12:10]

    This is my note.

    [12:12]

    This is another note.
    LOG

    expected_entries = [
      {log_entry: {time: "12:10", note: "\nThis is my note.\n\n"}},
      {log_entry: {time: "12:12", note: "\nThis is another note.\n"}},
    ]
    expect(Logbook::Parser.new.parse_with_debug(logbook)).to eq(expected_entries)
  end

  it "parses task entries" do
    logbook = <<~LOG
    [12:10] [Start] My task
            [ID: uuid-1234] [Jira: LGBK-123]
            [Parent: uuid-2345]

    This is my note.
    LOG

    properties = [
      {name:  "ID", value: "uuid-1234"},
      {name: "Jira", value: "LGBK-123"},
      {name:  "Parent", value: "uuid-2345"}
    ]

    expected_entries = [
      {
        task_entry: {
          time: "12:10",
          status: "Start",
          title: "My task",
          properties: properties,
          note: "This is my note.\n"
        }
      }
    ]
    expect(Logbook::Parser.new.parse_with_debug(logbook)).to eq(expected_entries)
  end

  it "ignores free text" do
    logbook = <<~LOG
    This text will be ignored.

    [12:10]
    This is my note.
    LOG

    expected_entries = [
      {log_entry: {time: "12:10", note: "This is my note.\n"}}
    ]
    expect(Logbook::Parser.new.parse_with_debug(logbook)).to eq(expected_entries)
  end
end
