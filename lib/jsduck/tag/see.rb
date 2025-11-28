require "jsduck/tag/tag"
require 'jsduck/util/html'

module JsDuck::Tag
  # Implementation of @see tag for Javadoc support.
  #
  # Documents cross-references to related classes, methods, or fields.
  # This tag is repeatable - multiple @see tags can be used.
  #
  # @example
  #   /**
  #    * @see MyOtherClass
  #    * @see #methodName()
  #    * @see java.util.List
  #    */
  #   public class MyClass { }
  #
  class See < Tag
    def initialize
      @pattern = "see"
      @tagname = :see
      @repeatable = true
      @html_position = POS_SEE
    end

    # Parses the reference from doc comment.
    # Accepts any text after @see tag (class names, method names, URLs, etc.)
    def parse_doc(p, pos)
      {
        :tagname => :see,
        :reference => p.match(/.*$/).strip,
      }
    end

    # Stores all @see references as an array in the member documentation.
    # Multiple @see tags are supported.
    def process_doc(h, tags, pos)
      h[:see] = tags.map {|t| t[:reference] }
    end

    # Renders the "See also" section in HTML with all references.
    def to_html(context)
      return "" unless context[:see] && context[:see].length > 0

      refs = context[:see].map do |ref|
        # Try to detect if it's a URL or a class/method reference
        if ref =~ /^https?:\/\//
          # It's a URL - render as link
          "<li><a href=\"#{JsDuck::Util::HTML.escape(ref)}\" target=\"_blank\">#{JsDuck::Util::HTML.escape(ref)}</a></li>"
        else
          # It's a class/method reference - render as plain text (could be enhanced to link to docs)
          "<li>#{JsDuck::Util::HTML.escape(ref)}</li>"
        end
      end.join("\n")

      <<-EOHTML
        <p><strong>See also:</strong></p>
        <ul>
          #{refs}
        </ul>
      EOHTML
    end

  end
end
