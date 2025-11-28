require "jsduck/tag/tag"
require 'jsduck/util/html'

module JsDuck::Tag
  # Implementation of @author tag for Javadoc support.
  #
  # Documents the author(s) of a class, interface, or method.
  # This tag is repeatable - multiple @author tags can be used.
  #
  # Supports both Javadoc formats:
  # - @author Name
  # - @author Name <email@example.com>
  #
  class Author < Tag
    def initialize
      @pattern = "author"
      @tagname = :author
      @repeatable = true
      @html_position = POS_AUTHOR
    end

    # Parses author information from doc comment.
    # Supports: @author Name <email@example.com>
    def parse_doc(p, pos)
      name = p.match(/[^<\n]*/).strip
      email = nil

      if p.look(/</)
        p.match(/</)
        email = p.match(/[^>\n]*/)
        p.match(/>/)
      end

      return {:tagname => @tagname, :name => name, :email => email}
    end

    # Stores all @author entries as an array in the member documentation.
    def process_doc(context, tags, pos)
      context[@tagname] = tags
    end

    # Renders the author information in HTML.
    def to_html(context)
      return "" unless context[:author] && context[:author].length > 0

      authors = context[:author].map do |author|
        name = JsDuck::Util::HTML.escape(author[:name])
        if author[:email]
          email = JsDuck::Util::HTML.escape(author[:email])
          "<li>#{name} &lt;#{email}&gt;</li>"
        else
          "<li>#{name}</li>"
        end
      end.join("\n")

      label = context[:author].length == 1 ? "Author:" : "Authors:"

      <<-EOHTML
        <p><strong>#{label}</strong></p>
        <ul>
          #{authors}
        </ul>
      EOHTML
    end

  end
end
