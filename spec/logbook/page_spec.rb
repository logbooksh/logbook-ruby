require "spec_helper"

module Logbook
  RSpec.describe Page do
    it "knows which entry is at a given line" do
      page = Page.new

      first_entry = TaskEntry.new(1)
      second_entry = TaskEntry.new(5)
      third_entry = TaskEntry.new(9)

      page.add(first_entry)
      page.add(second_entry)
      page.add(third_entry)

      expect(page.entry_at(1)).to eq(first_entry)
      expect(page.entry_at(5)).to eq(second_entry)
      expect(page.entry_at(9)).to eq(third_entry)

      expect(page.entry_at(3)).to eq(first_entry)
      expect(page.entry_at(7)).to eq(second_entry)
      expect(page.entry_at(13)).to eq(third_entry)
    end

    describe "tasks" do
      let(:page) { Page.new }
      let(:properties) { {"Date" => Property.new("Date", "2018-01-24"), "ID" => Property.new("ID", "my-task")} }

      it "builds tasks based on task entries using the ID property" do
        [
          TaskEntry.new(1, "12:00", "My task", Task::START, properties),
          TaskEntry.new(2, "12:30", "My task", Task::PAUSE, properties)
        ].each { |entry| page.add(entry) }

        expect(page.tasks.count).to eq(1)
        expect(page.tasks["my-task"].title).to eq("My task")
        expect(page.tasks["my-task"].status).to eq(Task::PAUSE)
        expect(page.tasks["my-task"].properties["ID"].value).to eq("my-task")
        expect(page.tasks["my-task"].time_logged).to eq(Duration.new(30))
      end
    end

    describe "#logged_time" do
      let(:page) { Page.new }
      let(:properties) { {"Date" => Property.new("Date", "2018-01-24")} }

      it "computes the total amount of time logged in the page based on entry statuses" do
        [
          TaskEntry.new(1, "12:00", "", Task::START, properties),
          TaskEntry.new(1, "12:30", "", Task::PAUSE, properties)
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "stops the clock after a Start status" do
        [
          TaskEntry.new(1, "12:00", "", Task::START, properties),
          TaskEntry.new(1, "12:30", "", Task::START, properties)
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "stops the clock after a Resume status" do
        [
          TaskEntry.new(1, "12:00", "", Task::START, properties),
          TaskEntry.new(1, "12:30", "", Task::RESUME, properties)
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "restarts the clock after a Reopen status" do
        [
          TaskEntry.new(1, "12:00", "", Task::START, properties),
          TaskEntry.new(1, "12:30", "", Task::REOPEN, properties)
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "stops the clock after a log entry" do
        first_entry = TaskEntry.new(1, "12:00", "", Task::START, properties)
        second_entry = LogEntry.new(1, "12:30", "")
        second_entry.properties = properties

        page.add(first_entry)
        page.add(second_entry)

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "ignores invalid sequences of statuses" do
        [
          TaskEntry.new(1, "12:00", "", Task::PAUSE, properties),
          TaskEntry.new(1, "12:30", "", Task::DONE, properties),
          TaskEntry.new(1, "13:00", "", Task::RESUME, properties),
          TaskEntry.new(1, "13:30", "", Task::PAUSE, properties),
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end
    end
  end
end
