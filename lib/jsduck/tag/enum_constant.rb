require "jsduck/tag/member_tag"

module JsDuck::Tag
  # Implementation of enum constant tag for Java enums.
  #
  # Enum constants are extracted from Java enum declarations
  # and displayed as a separate member type.
  class EnumConstant < MemberTag
    def initialize
      @pattern = "enum_constant"
      @tagname = :enum_constant
      @member_type = {
        :title => "Enum Constants",
        :position => MEMBER_POS_ENUM_CONSTANT,
        :icon => File.dirname(__FILE__) + "/icons/property.png",
      }
    end

    # This tag is only auto-detected from code, not parsed from doc comments
    def parse_doc(p, pos)
      nil
    end

    def process_code(code)
      h = super(code)
      h[:arguments] = code[:arguments] if code[:arguments]
      h
    end

    def to_html(constant, cls)
      member_link(constant)
    end
  end
end
