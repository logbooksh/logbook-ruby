module Logbook
  class Property
    attr_accessor :name, :value

    TAG_VALUE = nil

    def initialize(name, value = TAG_VALUE)
      @name = name
      @value = value
    end

    def has_value?
      !is_tag? && !value.strip.empty?
    end

    def is_tag?
      self.value === TAG_VALUE
    end
  end
end
