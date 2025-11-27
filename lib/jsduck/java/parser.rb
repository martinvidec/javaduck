require 'json'
require 'open3'
require 'tempfile'

module JsDuck
  module Java

    # A Java parser implementation that uses JavaParser CLI and outputs
    # results in the same format as Js::Parser.
    #
    # This parser shells out to a Java-based CLI tool that uses the
    # JavaParser library to parse Java source code and extract documentation.
    class Parser

      def initialize(input, options={})
        @input = input
        @options = options
      end

      # Parses Java source code with JavaParser CLI.
      # Returns array of docsets in JSDuck format:
      #
      #     [
      #       {
      #         :comment => "Javadoc comment content",
      #         :code => {...code structure...},
      #         :linenr => 12,
      #         :type => :doc_comment
      #       }
      #     ]
      #
      def parse
        # Write Java source to temp file
        temp_file = Tempfile.new(['java_source', '.java'])
        begin
          temp_file.write(@input)
          temp_file.close

          # Call JavaParser CLI
          stdout, stderr, status = Open3.capture3(
            'java', '-jar', jar_path,
            temp_file.path
          )

          unless status.success?
            raise syntax_error(stderr)
          end

          # Parse JSON output
          json_result = JSON.parse(stdout)

          # Convert to JSDuck format (symbols instead of strings)
          convert_to_jsduck_format(json_result)
        ensure
          temp_file.unlink
        end
      end

      private

      # Returns the path to the JavaParser CLI JAR file.
      # Checks multiple locations in order:
      # 1. JAVAPARSER_JAR environment variable
      # 2. lib/jsduck/java/javaparser-cli.jar (installed location)
      # 3. poc/java-parser/target/javaparser-cli.jar (development location)
      def jar_path
        # Check environment variable
        if ENV['JAVAPARSER_JAR'] && File.exist?(ENV['JAVAPARSER_JAR'])
          return ENV['JAVAPARSER_JAR']
        end

        # Check installed location
        installed_jar = File.expand_path('../javaparser-cli.jar', __FILE__)
        return installed_jar if File.exist?(installed_jar)

        # Check PoC location (for development)
        poc_jar = File.expand_path('../../../../poc/java-parser/target/javaparser-cli.jar', __FILE__)
        return poc_jar if File.exist?(poc_jar)

        raise "JavaParser CLI JAR not found. Please set JAVAPARSER_JAR environment variable or install the JAR to lib/jsduck/java/javaparser-cli.jar"
      end

      # Converts JSON output from JavaParser CLI to JSDuck internal format
      # (using symbols instead of strings for hash keys)
      def convert_to_jsduck_format(json_array)
        json_array.map do |docset|
          {
            :comment => docset['comment'] || '',
            :code => convert_code(docset['code']),
            :linenr => docset['linenr'] || 0,
            :type => docset['type'] == 'doc_comment' ? :doc_comment : :plain_comment
          }
        end
      end

      # Converts code structure from JSON to symbol-keyed hash
      def convert_code(code_json)
        return nil unless code_json

        code = {
          :tagname => code_json['tagname'].to_sym,
          :name => code_json['name']
        }

        # Modifiers
        [:public, :private, :protected, :static, :final, :abstract].each do |mod|
          code[mod] = code_json[mod.to_s] if code_json.key?(mod.to_s)
        end

        # Inheritance
        code[:extends] = code_json['extends'] if code_json['extends']
        code[:implements] = code_json['implements'] if code_json['implements']

        # Type-specific fields
        code[:return_type] = code_json['return_type'] if code_json['return_type']
        code[:type] = code_json['type'] if code_json['type']
        code[:default] = code_json['default'] if code_json['default']
        code[:throws] = code_json['throws'] if code_json['throws']

        # Parameters
        if code_json['params']
          code[:params] = code_json['params'].map do |param|
            {
              :name => param['name'],
              :type => param['type']
            }
          end
        end

        # Members (recursive)
        if code_json['members']
          code[:members] = code_json['members'].map do |member|
            member_code = convert_code(member)
            # Members can have their own comments
            if member['comment']
              member_code[:comment] = member['comment']
            end
            if member['linenr']
              member_code[:linenr] = member['linenr']
            end
            member_code
          end
        end

        code
      end

      def syntax_error(stderr)
        "Invalid Java syntax: #{stderr}"
      end
    end

  end
end
