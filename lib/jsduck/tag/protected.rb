require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class Protected < BooleanTag
    def initialize
      @pattern = "protected"
      @signature = {:long => "protected", :short => "PRO"}
      @css = <<-EOCSS
        .signature .protected {
          background-color: #9B86FC;
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
