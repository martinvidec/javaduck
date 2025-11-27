#!/usr/bin/env ruby
# Test script for JavaParser CLI integration

require 'json'
require 'open3'
require 'tempfile'

class JavaParserCLI
  def initialize(jar_path)
    @jar_path = jar_path
    raise "JavaParser JAR not found: #{jar_path}" unless File.exist?(jar_path)
  end

  def parse(java_source)
    # Write Java source to temp file
    temp_file = Tempfile.new(['java_source', '.java'])
    temp_file.write(java_source)
    temp_file.close

    begin
      # Call JavaParser CLI
      stdout, stderr, status = Open3.capture3(
        'java', '-jar', @jar_path,
        temp_file.path
      )

      unless status.success?
        raise "JavaParser failed: #{stderr}"
      end

      # Parse JSON output
      JSON.parse(stdout)
    ensure
      temp_file.unlink
    end
  end
end

# Main test
if __FILE__ == $0
  jar_path = File.join(__dir__, 'target/javaparser-cli.jar')

  unless File.exist?(jar_path)
    puts "❌ JAR not found. Build it first with: mvn clean package"
    puts "Expected location: #{jar_path}"
    exit 1
  end

  parser = JavaParserCLI.new(jar_path)

  # Read test Java file
  test_file = File.join(__dir__, 'TestClass.java')
  java_source = File.read(test_file)

  puts "📝 Parsing TestClass.java..."
  puts "=" * 60

  begin
    result = parser.parse(java_source)

    puts "✅ Parsing successful!"
    puts
    puts "📊 Results:"
    puts "-" * 60

    result.each do |docset|
      code = docset['code']
      puts
      puts "Type: #{code['tagname']}"
      puts "Name: #{code['name']}"
      puts "Public: #{code['public']}"
      puts "Extends: #{code['extends']}" if code['extends']
      puts "Implements: #{code['implements'].join(', ')}" if code['implements']
      puts "Javadoc: #{docset['comment'][0..80]}..." if docset['comment'] && !docset['comment'].empty?
      puts
      puts "Members (#{code['members'].length}):"

      code['members'].each do |member|
        case member['tagname']
        when 'constructor'
          params = member['params'].map { |p| "#{p['type']} #{p['name']}" }.join(', ')
          puts "  - Constructor: #{member['name']}(#{params})"
        when 'method'
          params = member['params'].map { |p| "#{p['type']} #{p['name']}" }.join(', ')
          puts "  - Method: #{member['return_type']} #{member['name']}(#{params})"
        when 'field'
          puts "  - Field: #{member['type']} #{member['name']}"
        end
      end
    end

    puts
    puts "=" * 60
    puts "✅ Test completed successfully!"
    puts
    puts "📋 Summary:"
    puts "  - Classes parsed: #{result.length}"
    puts "  - Total members: #{result.sum { |r| r['code']['members'].length }}"

    # Save JSON for inspection
    output_file = 'test_output.json'
    File.write(output_file, JSON.pretty_generate(result))
    puts
    puts "💾 Full output saved to: #{output_file}"

  rescue => e
    puts "❌ Error: #{e.message}"
    puts e.backtrace
    exit 1
  end
end
