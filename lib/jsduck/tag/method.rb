require "jsduck/tag/member_tag"
require "jsduck/params_merger"

module JsDuck::Tag
  # Implementation of @method tag.
  class Method < MemberTag
    def initialize
      @pattern = "method"
      @tagname = :method
      @member_type = {
        :title => "Methods",
        :position => MEMBER_POS_METHOD,
        :icon => File.dirname(__FILE__) + "/icons/method.png",
        :subsections => [
          {:title => "Instance methods", :filter => {:static => false}, :default => true},
          {:title => "Static methods", :filter => {:static => true}},
        ]
      }
    end

    # @method name ...
    def parse_doc(p, pos)
      {
        :tagname => :method,
        :name => p.ident,
      }
    end

    # Onle sets the name when it's actually specified.
    # Otherwise we might overwrite name coming from @constructor.
    def process_doc(h, tags, pos)
      h[:name] = tags[0][:name] if tags[0][:name]
    end

    def process_code(code)
      h = super(code)
      h[:params] = code[:params]
      h[:chainable] = code[:chainable]
      h[:fires] = code[:fires]
      h[:method_calls] = code[:method_calls]
      h[:return_type] = code[:return_type] if code[:return_type]
      h
    end

    def merge(h, docs, code)
      JsDuck::ParamsMerger.merge(h, docs, code)
      merge_return_type(h, docs, code)
    end

    private

    # Merges return type from code when @return tag doesn't specify type (Javadoc style).
    # In Javadoc, @return only has description, type comes from method signature.
    def merge_return_type(h, docs, code)
      # If @return exists but has no type or default "Object" type, use code type
      if h[:return] && code[:return_type]
        if !h[:return][:type] || h[:return][:type] == "Object"
          h[:return][:type] = code[:return_type]
        end
      elsif !h[:return] && code[:return_type] && code[:return_type] != "void"
        # Auto-detect return when not documented but present in code (except void)
        h[:return] = {
          :type => code[:return_type],
          :name => "return",
          :doc => "",
          :properties => []
        }
      end
    end

    public

    def to_html(m, cls)
      modifiers(m) + new_kw(m) + method_link(m, cls) + member_params(m[:params]) + return_value(m)
    end

    private

    def modifiers(m)
      mods = []
      mods << "public" if m[:public]
      mods << "private" if m[:private]
      mods << "protected" if m[:protected]
      mods << "static" if m[:static]
      mods << "final" if m[:final]
      mods << "abstract" if m[:abstract]

      mods.empty? ? "" : "<span class='modifiers'>#{mods.join(' ')}</span> "
    end

    def new_kw(m)
      constructor?(m) ? "<strong class='new-keyword'>new</strong>" : ""
    end

    def method_link(m, cls)
      if constructor?(m)
        member_link(:owner => m[:owner], :id => m[:id], :name => cls[:name])
      else
        member_link(m)
      end
    end

    def constructor?(m)
      m[:name] == "constructor"
    end

    def return_value(m)
      m[:return] ? (" : " + m[:return][:html_type]) : ""
    end

  end
end
