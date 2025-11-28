require "jsduck/tag/tag"
require 'jsduck/util/html'

module JsDuck::Tag
  # Implementation of @version tag for Javadoc support.
  #
  # Documents the version number of a class, interface, or package.
  # Common in Javadoc but also useful for JavaScript libraries.
  #
  # @example
  #   /**
  #    * @version 1.0.0
  #    */
  #   public class MyClass { }
  #
  class Version < Tag
    def initialize
      @pattern = "version"
      @tagname = :version
      @html_position = POS_VERSION
    end

    # Parses the version string from doc comment.
    # Accepts any text after @version tag.
    def parse_doc(p, pos)
      {
        :tagname => :version,
        :version => p.match(/.*$/).strip,
      }
    end

    # Stores the version string in the member documentation.
    def process_doc(h, tags, pos)
      h[:version] = tags[0][:version]
    end

    # Renders the version information in HTML.
    def to_html(context)
      <<-EOHTML
        <p>Version: <b>#{JsDuck::Util::HTML.escape(context[:version])}</b></p>
      EOHTML
    end

  end
end
