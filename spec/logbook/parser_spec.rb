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
      {property: {name:  "ID", value: "uuid-1234"}},
      {property: {name: "Jira", value: "LGBK-123"}},
      {property: {name:  "Parent", value: "uuid-2345"}}
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

  it "parses task definitions" do
    logbook = <<~LOG
    [ToDo] My task

           [ID: uuid-1234]
           [Jira: LGBK-123]

    This is my note.

    [ToDo] My other task
           #my-tag

    Another note.
    LOG

    properties = [
      {property: {name:  "ID", value: "uuid-1234"}},
      {property: {name: "Jira", value: "LGBK-123"}}
    ]

    expected_definitions = [
      {
        task_definition: {
          status: "ToDo",
          title: "My task",
          properties: properties,
          note: "This is my note.\n\n"
        }
      },
      {
        task_definition: {
          status: "ToDo",
          title: "My other task",
          properties: [{tag: "my-tag"}],
          note: "Another note.\n"
        }
      }
    ]

    expect(Logbook::Parser.new.parse_with_debug(logbook)).to eq(expected_definitions)
  end

  it "allows properties in between task entries" do
    logbook = <<~LOG
    [ToDo] My task

           [ID: uuid-1234]
           [Jira: LGBK-123]

    This is my note.

    [Release: 2.0]

    [ToDo] My other task
           #my-tag

    Another note.
    LOG

    expected_property = {property: {name:  "Release", value: "2.0"}}

    _, parsed_property, _ = Logbook::Parser.new.parse_with_debug(logbook)
    expect(parsed_property).to eq(expected_property)
  end

  it "allows for the file not to finish with a newline" do
    logbook = <<~LOG
    [ToDo] My task

    This is my note.
    LOG

    task_definition, _ = Logbook::Parser.new.parse_with_debug(logbook.chomp)
    expect(task_definition[:task_definition][:note]).to eq("This is my note.")
  end

  it "ignores unrelated text" do
    logbook = <<~LOG
    This text will be ignored.

    [12:10]
    This is my note.
    LOG

    expected_entry = {log_entry: {time: "12:10", note: "This is my note.\n"}}

    expect(Logbook::Parser.new.parse_with_debug(logbook)).to eq([expected_entry])
  end
end
