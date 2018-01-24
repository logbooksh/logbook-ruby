require "parslet"

module Logbook
  class Builder < Parslet::Transform
    rule(tag: simple(:tag)) { Tag.new(tag.to_s) }

    rule(property: {name: simple(:name), value: simple(:value)}) do
      Property.new(name.to_s, value.to_s)
    end

    rule(log_entry: subtree(:log)) do
      line_number, _ = log[:time].line_and_column
      note = log[:note].to_s.strip.chomp

      LogEntry.new(line_number, log[:time].to_s, note)
    end

    rule(task_definition: subtree(:task)) do
      properties =  task[:properties].select { |item| item.instance_of?(Property) }.map { |property| [property.name, property.value] }.to_h
      tags =  task[:properties].select { |item| item.instance_of?(Tag) }
      line_number, _ = task[:status].line_and_column
      note = task[:note].to_s.strip.chomp

      TaskDefinition.new(line_number, task[:title].to_s, task[:status].to_s, properties, tags, note)
    end

    rule(task_entry: subtree(:task)) do
      properties =  task[:properties].select { |item| item.instance_of?(Property) }.map { |property| [property.name, property.value] }.to_h
      tags =  task[:properties].select { |item| item.instance_of?(Tag) }
      line_number, _ = task[:status].line_and_column
      note = task[:note].to_s.strip.chomp

      TaskEntry.new(line_number, task[:time].to_s, task[:title].to_s, task[:status].to_s, properties, tags, note)
    end

    def self.build(contents)
      current_properties = {}
      entries_and_properties = new.apply(Parser.new.parse(contents))

      logbook_page = entries_and_properties.inject(Page.new) do |page, entry_or_property|
        case entry_or_property
        when Property
          current_properties[entry_or_property.name] = entry_or_property.value
          page
        when TaskDefinition, TaskEntry
          entry_or_property.merge_page_properties(current_properties)
          page.add(entry_or_property)
          page
        when LogEntry
          entry_or_property.properties = current_properties.dup
          page.add(entry_or_property)
          page
        else
          page
        end
      end

      logbook_page.properties = current_properties
      logbook_page
    end
  end
end
