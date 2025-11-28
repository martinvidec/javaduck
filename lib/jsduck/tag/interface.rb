require "jsduck/tag/tag"

module JsDuck::Tag
  # Tag for marking Java interfaces
  # Similar to @class but specifically for interfaces
  class Interface < Tag
    def initialize
      @pattern = "interface"
      @tagname = :interface
      @class_icon = {
        :small => File.dirname(__FILE__) + "/icons/interface.png",
        :large => File.dirname(__FILE__) + "/icons/interface-large.png",
        :redirect => File.dirname(__FILE__) + "/icons/interface-redirect.png",
        :priority => PRIORITY_INTERFACE,
      }
      @signature = {:long => "interface", :short => "INT"}
      # Blue box to differentiate from classes
      @css = <<-EOCSS
        .interface-box {
          color: #006;
          background-color: #eef;
          text-align: center;
        }
        .signature .interface {
          background-color: #3366cc;
          color: white;
        }
      EOCSS
    end

    # @interface name
    def parse_doc(p, pos)
      {
        :tagname => :interface,
        :name => p.ident_chain,
      }
    end

    def process_doc(h, tags, pos)
      h[:name] = tags[0][:name]
      # Mark as interface for rendering
      h[:interface] = true
    end

    # Auto-detect interface from code
    def process_code(code)
      if code[:tagname] == :interface
        code
      else
        {:name => code[:name] }
      end
    end

    def merge(h, docs, code)
      # Ensure the empty members array
      h[:members] = []
      # Interfaces don't extend Object
      h[:extends] = nil if h[:extends] == "Object"
      # Default alternateClassNames list to empty array
      h[:alternateClassNames] = [] unless h[:alternateClassNames]
      # Mark as interface
      h[:interface] = true
    end

    def to_html(cls)
      if cls[:interface]
        [
          "<div class='rounded-box interface-box'>",
          "<p><strong>INTERFACE:</strong> ",
          "This is a Java interface.</p>",
          "</div>",
        ]
      else
        []
      end
    end

  end
end
