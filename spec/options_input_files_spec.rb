require "jsduck/options/input_files"
require "tmpdir"
require "fileutils"

describe JsDuck::Options::InputFiles do

  # Simple mock object for options
  class MockOptions
    attr_accessor :input_files, :exclude

    def initialize
      @input_files = []
      @exclude = []
    end
  end

  describe "#expand!" do
    before :each do
      @tmpdir = Dir.mktmpdir
      @opts = MockOptions.new
      @input_files = JsDuck::Options::InputFiles.new(@opts)
    end

    after :each do
      FileUtils.rm_rf(@tmpdir)
    end

    it "expands directory with .js files" do
      js_file = File.join(@tmpdir, "test.js")
      File.write(js_file, "// test")

      @opts.input_files = [@tmpdir]
      @input_files.expand!

      @opts.input_files.should include(js_file)
    end

    it "expands directory with .scss files" do
      scss_file = File.join(@tmpdir, "test.scss")
      File.write(scss_file, "/* test */")

      @opts.input_files = [@tmpdir]
      @input_files.expand!

      @opts.input_files.should include(scss_file)
    end

    it "expands directory with .java files" do
      java_file = File.join(@tmpdir, "Test.java")
      File.write(java_file, "// test")

      @opts.input_files = [@tmpdir]
      @input_files.expand!

      @opts.input_files.should include(java_file)
    end

    it "expands directory recursively for .java files" do
      subdir = File.join(@tmpdir, "src", "com", "example")
      FileUtils.mkdir_p(subdir)
      java_file = File.join(subdir, "MyClass.java")
      File.write(java_file, "package com.example; public class MyClass {}")

      @opts.input_files = [@tmpdir]
      @input_files.expand!

      @opts.input_files.should include(java_file)
    end

    it "expands directory with mixed .js, .scss, and .java files" do
      js_file = File.join(@tmpdir, "test.js")
      scss_file = File.join(@tmpdir, "test.scss")
      java_file = File.join(@tmpdir, "Test.java")

      File.write(js_file, "// js")
      File.write(scss_file, "/* scss */")
      File.write(java_file, "// java")

      @opts.input_files = [@tmpdir]
      @input_files.expand!

      @opts.input_files.should include(js_file)
      @opts.input_files.should include(scss_file)
      @opts.input_files.should include(java_file)
    end

    it "excludes files matching exclude patterns" do
      java_file = File.join(@tmpdir, "Test.java")
      excluded_file = File.join(@tmpdir, "Excluded.java")

      File.write(java_file, "// test")
      File.write(excluded_file, "// excluded")

      @opts.input_files = [@tmpdir]
      @opts.exclude = [excluded_file]
      @input_files.expand!

      @opts.input_files.should include(java_file)
      @opts.input_files.should_not include(excluded_file)
    end
  end

end
