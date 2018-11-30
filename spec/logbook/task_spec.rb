require "spec_helper"

module Logbook
  RSpec.describe Task do
    describe "#status" do
      it "is Todo when the task has no entries" do
        expect(Task.new("task-id").status).to eq(Task::Status::TODO)
      end

      it "is based on the status of the most recent entry" do
        task_one = Task.new("task-1")
        task_two = Task.new("task-2")

        properties = {"Date" => "2018-03-23"}
        older_entry = TaskEntry.new(time: "10:00", status: TaskEntry::Status::TODO, properties: properties)
        most_recent_entry = TaskEntry.new(time: "12:00", status: TaskEntry::Status::START, properties: properties)

        task_one.add_entry(older_entry)
        task_one.add_entry(most_recent_entry)

        task_two.add_entry(most_recent_entry)
        task_two.add_entry(older_entry)

        expect(task_one.status).to eq(Task::Status::ONGOING)
        expect(task_two.status).to eq(Task::Status::ONGOING)
      end

      it "allows any transition between statuses" do
        task = Task.new("task-1")
        properties = {"Date" => "2018-03-23"}

        todo_entry = TaskEntry.new(time: "10:00", status: TaskEntry::Status::TODO, properties: properties)
        task.add_entry(todo_entry)
        expect(task.status).to eq(Task::Status::TODO)

        start_entry = TaskEntry.new(time: "11:00", status: TaskEntry::Status::START, properties: properties)
        task.add_entry(start_entry)
        expect(task.status).to eq(Task::Status::ONGOING)

        pause_entry = TaskEntry.new(time: "12:00", status: TaskEntry::Status::PAUSE, properties: properties)
        task.add_entry(pause_entry)
        expect(task.status).to eq(Task::Status::ONGOING)

        resume_entry = TaskEntry.new(time: "13:00", status: TaskEntry::Status::RESUME, properties: properties)
        task.add_entry(resume_entry)
        expect(task.status).to eq(Task::Status::ONGOING)

        done_entry = TaskEntry.new(time: "14:00", status: TaskEntry::Status::DONE, properties: properties)
        task.add_entry(done_entry)
        expect(task.status).to eq(Task::Status::DONE)

        reopen_entry = TaskEntry.new(time: "15:00", status: TaskEntry::Status::REOPEN, properties: properties)
        task.add_entry(reopen_entry)
        expect(task.status).to eq(Task::Status::ONGOING)

        todo_entry = TaskEntry.new(time: "16:00", status: TaskEntry::Status::TODO, properties: properties)
        task.add_entry(todo_entry)
        expect(task.status).to eq(Task::Status::TODO)
      end
    end
  end
end
