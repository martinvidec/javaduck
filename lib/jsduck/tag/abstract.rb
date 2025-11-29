require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class Abstract < BooleanTag
    def initialize
      @pattern = "abstract"
      @signature = {:long => "abstract", :short => "ABS"}
      @css = <<-EOCSS
        .signature .abstract {
          background-color: #888;
          color: white;
          padding: 0 5px;
          margin-left: 2px;
          border-radius: 3px;
        }
      EOCSS
      super
    end
  end
end
