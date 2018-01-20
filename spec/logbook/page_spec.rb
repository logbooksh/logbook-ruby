require "spec_helper"

RSpec.describe Logbook::Page do
  it "knows which entry is entry_at a given line" do
    page = Logbook::Page.new

    Entry = Struct.new(:line_number)
    first_entry = Entry.new(1)
    second_entry = Entry.new(5)
    third_entry = Entry.new(9)

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
end
