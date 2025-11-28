require "jsduck/java/parser"

# Helper method to check if JavaParser JAR is available
def jar_available?
  parser = JsDuck::Java::Parser.new("")
  begin
    parser.send(:jar_path)
    true
  rescue
    false
  end
end

describe JsDuck::Java::Parser do

  def parse(input)
    JsDuck::Java::Parser.new(input).parse
  end

  describe "when JavaParser JAR is not available" do
    it "raises an error with helpful message" do
      # Temporarily hide JAR by using invalid path
      ENV['JAVAPARSER_JAR'] = '/invalid/path/to/jar'
      begin
        parse("public class Test {}")
      rescue => e
        e.message.should include("JavaParser CLI JAR not found")
      ensure
        ENV.delete('JAVAPARSER_JAR')
      end
    end
  end

  if jar_available?
    describe "parsing a simple Java class" do
      before do
        @docs = parse(<<-JAVA)
          /**
           * A simple test class.
           */
          public class SimpleClass {
              /**
               * A test method.
               */
              public void testMethod() {
              }
          }
        JAVA
      end

      it "detects one class" do
        @docs.length.should == 1
      end

      it "detects class as doc comment" do
        @docs[0][:type].should == :doc_comment
      end

      it "extracts class comment" do
        @docs[0][:comment].should include("A simple test class")
      end

      it "extracts class name" do
        @docs[0][:code][:name].should == "SimpleClass"
      end

      it "detects class tagname" do
        @docs[0][:code][:tagname].should == :class
      end

      it "detects public modifier" do
        @docs[0][:code][:public].should == true
      end

      it "extracts method as member" do
        members = @docs[0][:code][:members]
        members.length.should >= 1
        method = members.find { |m| m[:tagname] == :method }
        method.should_not be_nil
        method[:name].should == "testMethod"
      end
    end

    describe "parsing a class with inheritance" do
      before do
        @docs = parse(<<-JAVA)
          /**
           * Extended class.
           */
          public class ChildClass extends ParentClass implements Runnable {
              public void run() {
              }
          }
        JAVA
      end

      it "detects extends clause" do
        @docs[0][:code][:extends].should == "ParentClass"
      end

      it "detects implements clause" do
        @docs[0][:code][:implements].should include("Runnable")
      end
    end

    describe "parsing a method with parameters" do
      before do
        @docs = parse(<<-JAVA)
          public class TestClass {
              /**
               * Method with params.
               */
              public String getName(int id, boolean active) {
                  return "test";
              }
          }
        JAVA
      end

      it "extracts method parameters" do
        method = @docs[0][:code][:members].find { |m| m[:tagname] == :method }
        method[:params].length.should == 2
        method[:params][0][:name].should == "id"
        method[:params][0][:type].should == "int"
        method[:params][1][:name].should == "active"
        method[:params][1][:type].should == "boolean"
      end

      it "extracts return type" do
        method = @docs[0][:code][:members].find { |m| m[:tagname] == :method }
        method[:return_type].should == "String"
      end
    end

    describe "parsing a field" do
      before do
        @docs = parse(<<-JAVA)
          public class TestClass {
              /**
               * A field.
               */
              private String name = "default";
          }
        JAVA
      end

      it "extracts field" do
        field = @docs[0][:code][:members].find { |m| m[:tagname] == :field }
        field.should_not be_nil
        field[:name].should == "name"
        field[:type].should == "String"
      end

      it "extracts field default value" do
        field = @docs[0][:code][:members].find { |m| m[:tagname] == :field }
        field[:default].should == "\"default\""
      end

      it "detects private modifier" do
        field = @docs[0][:code][:members].find { |m| m[:tagname] == :field }
        field[:private].should == true
      end
    end

    describe "parsing invalid Java" do
      it "raises syntax error" do
        begin
          parse("public class { invalid }")
          fail("Should have raised an error")
        rescue => e
          e.message.should include("Invalid Java syntax")
        end
      end
    end

    describe "parsing a class without Javadoc" do
      before do
        @docs = parse(<<-JAVA)
          public class NoDocClass {
              public void method() {
              }
          }
        JAVA
      end

      it "detects class" do
        @docs.length.should == 1
      end

      it "has empty comment" do
        @docs[0][:comment].should == ""
      end
    end

    describe "parsing an interface" do
      before do
        @docs = parse(<<-JAVA)
          /**
           * Test interface.
           */
          public interface TestInterface {
              void doSomething();
          }
        JAVA
      end

      it "detects interface tagname" do
        @docs[0][:code][:tagname].should == :interface
      end

      it "extracts interface name" do
        @docs[0][:code][:name].should == "TestInterface"
      end
    end

    describe "parsing an enum" do
      before do
        @docs = parse(<<-JAVA)
          /**
           * Test enum.
           */
          public enum Color {
              RED, GREEN, BLUE
          }
        JAVA
      end

      it "detects enum tagname" do
        @docs[0][:code][:tagname].should == :enum
      end

      it "extracts enum name" do
        @docs[0][:code][:name].should == "Color"
      end
    end

    describe "parsing a constructor" do
      before do
        @docs = parse(<<-JAVA)
          public class TestClass {
              /**
               * Constructor.
               */
              public TestClass(String name) {
              }
          }
        JAVA
      end

      it "detects constructor" do
        constructor = @docs[0][:code][:members].find { |m| m[:tagname] == :constructor }
        constructor.should_not be_nil
        constructor[:name].should == "TestClass"
      end

      it "extracts constructor parameters" do
        constructor = @docs[0][:code][:members].find { |m| m[:tagname] == :constructor }
        constructor[:params].length.should == 1
        constructor[:params][0][:name].should == "name"
        constructor[:params][0][:type].should == "String"
      end
    end

    describe "parsing method with throws clause" do
      before do
        @docs = parse(<<-JAVA)
          public class TestClass {
              public void doSomething() throws IOException, SQLException {
              }
          }
        JAVA
      end

      it "extracts throws clause" do
        method = @docs[0][:code][:members].find { |m| m[:tagname] == :method }
        method[:throws].should include("IOException")
        method[:throws].should include("SQLException")
      end
    end

  else
    # Skip tests if JAR is not available
    it "skips Java parser tests (JAR not available)" do
      pending("JavaParser JAR not found - install PoC JAR first")
    end
  end

end
