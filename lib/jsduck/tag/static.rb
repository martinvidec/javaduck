require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class Static < BooleanTag
    def initialize
      @pattern = "static"
      @signature = {:long => "static", :short => "STA"}
      @css = <<-EOCSS
        .signature .static {
          background-color: #484848;
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
