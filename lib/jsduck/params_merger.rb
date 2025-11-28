require "jsduck/logger"
require "jsduck/merger"

module JsDuck
  # Performs the merging of :params field.
  # Used by Method, Event and CssMixin members.
  class ParamsMerger
    # Ensures the existance of params array.
    # Merges types from code params when doc params don't have types (Javadoc style).
    # Defaults type of each parameter to "Object" if no type available.
    # Logs warnings for inconsistencies between params in code and in docs.
    def self.merge(h, docs, code)
      h[:params] = [] unless h[:params]

      # Merge types from code params into doc params (for Javadoc support)
      merge_types_from_code(h[:params], code[:params] || [])

      # Default any remaining typeless params to "Object"
      h[:params].each do |p|
        p[:type] = "Object" unless p[:type]
      end

      check_consistency(docs, code, h[:files].first)
    end

    # Merges type information from code params into doc params.
    # This supports Javadoc style where @param doesn't include type,
    # but JavaParser CLI provides the type from code.
    def self.merge_types_from_code(doc_params, code_params)
      doc_params.each do |doc_param|
        # Skip if doc param already has a type (JSDoc style)
        next if doc_param[:type]

        # Find matching code param by name
        code_param = code_params.find { |cp| cp[:name] == doc_param[:name] }

        # Merge type from code if found
        doc_param[:type] = code_param[:type] if code_param && code_param[:type]
      end
    end

    def self.check_consistency(docs, code, file)
      explicit = docs[:params] || []
      implicit = JsDuck::Merger.can_be_autodetected?(docs, code) ? (code[:params] || []) : []
      ex_len = explicit.length
      im_len = implicit.length

      if ex_len == 0 || im_len == 0
        # Skip when either no implicit or explicit params
      elsif ex_len != im_len && explicit.last[:type] =~ /\.\.\.$/
        # Skip when vararg params are in play.
      elsif ex_len < im_len
        # Warn when less parameters documented than found from code.
        JsDuck::Logger.warn(:param_count, "Detected #{im_len} params, but only #{ex_len} documented.", file)
      elsif ex_len > im_len
        # Warn when more parameters documented than found from code.
        JsDuck::Logger.warn(:param_count, "Detected #{im_len} params, but #{ex_len} documented.", file)
      elsif implicit.map {|p| p[:name] } != explicit.map {|p| p[:name] }
        # Warn when parameter names don't match up.
        ex_names = explicit.map {|p| p[:name] }
        im_names = implicit.map {|p| p[:name] }
        str = ex_names.zip(im_names).map {|p| ex, im = p; ex == im ? ex : (ex||"")+"/"+(im||"") }.join(", ")
        JsDuck::Logger.warn(:param_count, "Documented and auto-detected params don't match: #{str}", file)
      end
    end

  end
end
