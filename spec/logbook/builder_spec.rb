require "spec_helper"

RSpec.describe Logbook::Builder do
  describe "#build" do
    let(:contents) do
      <<~LOGBOOK
      [Date: 2018-01-20]
      [Project: One]
      [Release: 1.5]

      [ToDo] My other task
              [ID: uuid-1234]

      This is my note.

      [12:10] [Start] My task
              [ID: uuid-2345] [Jira: LGBK-123] [Jira: 123]
              [Release: 2.0]
              #my-tag #other-tag #my-tag

      This is my note.

      [Project: Two]

      [12:20]

      This is my simple log entry.
      LOGBOOK
    end

    let(:page) { Logbook::Builder.build(contents) }
    let(:task_entry) { page.entries.find { |entry| entry.instance_of?(Logbook::TaskEntry) } }
    let(:task_definition) { page.entries.find { |entry| entry.instance_of?(Logbook::TaskDefinition) } }
    let(:log_entry) { page.entries.find { |entry| entry.instance_of?(Logbook::LogEntry) } }

    it "builds a Page from a string" do
      expect(page.entries.count).to eq(3)
      expected_properties = {"Date" => "2018-01-20", "Project" => "Two", "Release" => "1.5"}
      expect(page.properties).to eq(expected_properties)
    end

    it "builds task definitions" do
      expect(task_definition.line_number).to eq(5)
      expect(task_definition.title).to eq("My other task")
      expect(task_definition.status).to eq("ToDo")
      expect(task_definition.properties["ID"]).to eq("uuid-1234")
      expect(task_definition.note).to eq("This is my note.")
    end

    it "builds task entries" do
      expect(task_entry.line_number).to eq(10)
      expect(task_entry.title).to eq("My task")
      expect(task_entry.status).to eq("Start")
      expect(task_entry.time).to eq("12:10")
      expect(task_entry.properties["ID"]).to eq("uuid-2345")
      expect(task_entry.tags).to include("other-tag")
      expect(task_entry.note).to eq("This is my note.")
    end

    it "builds log entries" do
      expect(log_entry.line_number).to eq(19)
      expect(log_entry.note).to eq("This is my simple log entry.")
    end

    it "keeps the last value of a property when there are multiple occurences" do
      expect(task_entry.properties["Jira"]).to eq("123")
      expect(page.properties["Project"]).to eq("Two")
    end

    it "merges the current page properties into task definitions and entries" do
      expect(task_entry.properties["Project"]).to eq("One")
    end

    it "keeps the task properties over the page properties" do
      expect(task_entry.properties["Release"]).to eq("2.0")
    end

    it "computes the recorded date and time of each entry" do
      expect(task_entry.recorded_at).to eq(DateTime.parse("2018-01-20 12:10"))
    end

    it "builds an empty page if there are no entries" do
      page = Logbook::Builder.build("Date: 29/30.")
      expect(page.entries).to be_empty
    end
  end
end
