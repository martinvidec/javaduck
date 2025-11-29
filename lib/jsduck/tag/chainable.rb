require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class Chainable < BooleanTag
    def initialize
      @pattern = "chainable"
      @signature = {:long => "chainable", :short => "&gt;"} # show small right-arrow
      @css = <<-EOCSS
        .signature .chainable {
          background-color: #00aa00;
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
