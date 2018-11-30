require "spec_helper"
require "set"

module Logbook
  RSpec.describe Page do
    it "knows which entry is at a given line" do
      page = Page.new

      first_entry = TaskEntry.new(line_number: 1, time: "")
      second_entry = TaskEntry.new(line_number: 5, time: "")
      third_entry = TaskEntry.new(line_number: 9, time: "")

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
      let(:properties) { {"Date" => "2018-01-24", "ID" => "my-task"} }

      it "builds tasks based on task entries using the ID property" do
        [
          TaskEntry.new(time: "12:00", title: "My task", status: TaskEntry::Status::START, properties: properties),
          TaskEntry.new(time: "12:30", title: "My task", status: TaskEntry::Status::PAUSE, properties: properties)
        ].each { |entry| page.add(entry) }

        expect(page.tasks.count).to eq(1)
        expect(page.tasks.first.title).to eq("My task")
        expect(page.tasks.first.properties["ID"]).to eq("my-task")
        expect(page.tasks.first.logged_time).to eq(Duration.new(30))
      end
    end

    describe "#logged_time" do
      let(:page) { Page.new }
      let(:properties) { {"Date" => "2018-01-24"} }

      it "computes the total amount of time logged in the page based on entry statuses" do
        [
          TaskEntry.new(time: "12:00", status: TaskEntry::Status::START, properties: properties),
          TaskEntry.new(time: "12:30", status: TaskEntry::Status::PAUSE, properties: properties)
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "stops the clock after a Start status" do
        [
          TaskEntry.new(time: "12:00", status: TaskEntry::Status::START, properties: properties),
          TaskEntry.new(time: "12:30", status: TaskEntry::Status::START, properties: properties)
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "stops the clock after a Resume status" do
        [
          TaskEntry.new(time: "12:00", status: TaskEntry::Status::START, properties: properties),
          TaskEntry.new(time: "12:30", status: TaskEntry::Status::RESUME, properties: properties)
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "restarts the clock after a Reopen status" do
        [
          TaskEntry.new(time: "12:00", status: TaskEntry::Status::START, properties: properties),
          TaskEntry.new(time: "12:30", status: TaskEntry::Status::REOPEN, properties: properties)
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "stops the clock after a log entry" do
        first_entry = TaskEntry.new(time: "12:00", status: TaskEntry::Status::START, properties: properties)
        second_entry = LogEntry.new(1, "12:30", "")
        second_entry.properties = properties

        page.add(first_entry)
        page.add(second_entry)

        expect(page.logged_time).to eq(Duration.new(30))
      end

      it "ignores invalid sequences of statuses" do
        [
          TaskEntry.new(time: "12:00", status: TaskEntry::Status::START, properties: properties),
          TaskEntry.new(time: "12:30", status: TaskEntry::Status::PAUSE, properties: properties),
          TaskEntry.new(time: "13:00", status: TaskEntry::Status::DONE, properties: properties),
          TaskEntry.new(time: "13:30", status: TaskEntry::Status::RESUME, properties: properties),
        ].each { |entry| page.add(entry) }

        expect(page.logged_time).to eq(Duration.new(30))
      end
    end
  end
end
