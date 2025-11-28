module JsDuck
  module Java

    # Processes Java AST to extract members from classes.
    #
    # Java parsing returns classes with nested members, but JSDuck expects
    # members to be separate docsets. This class extracts nested members
    # into separate docsets while preserving all their properties (including modifiers).
    class Ast

      def initialize(docs = [])
        @docs = docs
      end

      # Extracts nested members from classes into separate docsets.
      #
      # JavaParser CLI returns classes with members as nested structures:
      #   code: { tagname: :class, members: [...] }
      #
      # But JSDuck expects members as separate docsets:
      #   { code: { tagname: :method }, ... }
      #   { code: { tagname: :field }, ... }
      #
      # This method flattens the structure while preserving all member properties.
      def detect_all!
        result = []

        @docs.each do |docset|
          # Add the original docset (class, interface, enum)
          result << docset

          # If this is a class/interface/enum with members, extract them
          if docset[:code] && docset[:code][:members]
            docset[:code][:members].each do |member|
              # Create a new docset for each member
              member_docset = {
                :comment => member[:comment] || '',
                :code => member.dup,  # Copy all member properties
                :linenr => member[:linenr] || docset[:linenr],
                :type => :doc_comment
              }

              # Remove member-specific fields that shouldn't be in code
              member_docset[:code].delete(:comment)
              member_docset[:code].delete(:linenr)

              # Ensure the member has an owner set to the class name
              member_docset[:code][:owner] = docset[:code][:name]

              result << member_docset
            end

            # Remove members from class (they're now separate docsets)
            docset[:code].delete(:members)
          end
        end

        result
      end

    end

  end
end
