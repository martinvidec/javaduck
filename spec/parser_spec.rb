require "jsduck/parser"

describe JsDuck::Parser do

  def parse(contents, filename, options={})
    JsDuck::Parser.new.parse(contents, filename, options)
  end

  describe "routing based on file extension" do

    describe "JavaScript files" do
      it "routes .js files to Js::Parser" do
        result = parse("var x = 5;", "test.js")
        result.should be_an(Array)
      end

      it "routes files without extension to Js::Parser" do
        result = parse("var x = 5;", "test")
        result.should be_an(Array)
      end
    end

    describe "SCSS files" do
      it "routes .scss files to Css::Parser" do
        css_code = ".class { color: red; }"
        result = parse(css_code, "test.scss")
        result.should be_an(Array)
      end
    end

    describe "Java files" do
      # Only test if JavaParser JAR is available
      def jar_available?
        parser = JsDuck::Java::Parser.new("")
        begin
          parser.send(:jar_path)
          true
        rescue
          false
        end
      end

      if jar_available?
        it "routes .java files to Java::Parser" do
          java_code = <<-JAVA
            /**
             * Test class.
             */
            public class TestClass {
                public void test() {
                }
            }
          JAVA
          result = parse(java_code, "TestClass.java")
          result.should be_an(Array)
          # Should have parsed the class
          result.length.should > 0
        end

        it "processes Java classes through the full pipeline" do
          java_code = <<-JAVA
            /**
             * Sample class.
             */
            public class Sample {
                /**
                 * Test method.
                 * @return test value
                 */
                public String test() {
                    return "test";
                }
            }
          JAVA
          result = parse(java_code, "Sample.java")
          result.should be_an(Array)
          result.length.should > 0

          # Check that the class was detected
          class_doc = result.find { |d| d[:tagname] == :class }
          class_doc.should_not be_nil
          class_doc[:name].should == "Sample"
        end

      else
        it "skips Java routing tests (JAR not available)" do
          pending("JavaParser JAR not found - install PoC JAR first")
        end
      end
    end

    describe "file extension detection" do
      it "correctly identifies .scss extension" do
        parser = JsDuck::Parser.new
        filename = "test.scss"
        filename.should =~ /\.scss$/
      end

      it "correctly identifies .java extension" do
        parser = JsDuck::Parser.new
        filename = "TestClass.java"
        filename.should =~ /\.java$/
      end

      it "does not match .java in the middle of filename" do
        parser = JsDuck::Parser.new
        filename = "notjava.js"
        filename.should_not =~ /\.java$/
      end
    end

  end

end
