require "jsduck/java/parser"
require "jsduck/java/ast"
require "fileutils"

def jar_available?
  parser = JsDuck::Java::Parser.new("")
  begin
    parser.send(:jar_path)
    true
  rescue
    false
  end
end

describe "Java Integration Test" do

  if jar_available?
    describe "parsing real Java file" do
      before do
        java_file = File.read(File.dirname(__FILE__) + "/fixtures/java/SampleClass.java")
        docs = JsDuck::Java::Parser.new(java_file).parse
        @docs = JsDuck::Java::Ast.new(docs).detect_all!
        @class = @docs.find { |d| d[:code] && d[:code][:tagname] == :class }
      end

      it "detects the class" do
        @class.should_not be_nil
      end

      it "extracts class name" do
        @class[:code][:name].should == "SampleClass"
      end

      it "extracts extends clause" do
        @class[:code][:extends].should == "BaseClass"
      end

      it "extracts implements clause" do
        @class[:code][:implements].should include("Runnable")
      end

      it "extracts Javadoc comment" do
        @class[:comment].should include("sample Java class")
      end

      it "detects multiple members" do
        @class[:code][:members].length.should >= 5
      end

      describe "field extraction" do
        before do
          @name_field = @class[:code][:members].find { |m| m[:name] == "name" }
          @count_field = @class[:code][:members].find { |m| m[:name] == "count" }
        end

        it "extracts name field" do
          @name_field.should_not be_nil
          @name_field[:tagname].should == :field
          @name_field[:type].should == "String"
        end

        it "detects private modifier on name field" do
          @name_field[:private].should == true
        end

        it "extracts count field with default" do
          @count_field.should_not be_nil
          @count_field[:default].should == "0"
        end
      end

      describe "constructor extraction" do
        before do
          @constructor = @class[:code][:members].find { |m| m[:tagname] == :constructor }
        end

        it "detects constructor" do
          @constructor.should_not be_nil
        end

        it "extracts constructor parameter" do
          @constructor[:params].length.should == 1
          @constructor[:params][0][:name].should == "name"
          @constructor[:params][0][:type].should == "String"
        end
      end

      describe "method extraction" do
        before do
          @get_name = @class[:code][:members].find { |m| m[:name] == "getName" }
          @set_name = @class[:code][:members].find { |m| m[:name] == "setName" }
          @process_data = @class[:code][:members].find { |m| m[:name] == "processData" }
          @run = @class[:code][:members].find { |m| m[:name] == "run" }
        end

        it "extracts getName method" do
          @get_name.should_not be_nil
          @get_name[:tagname].should == :method
        end

        it "detects getName return type" do
          @get_name[:return_type].should == "String"
        end

        it "extracts setName with parameter" do
          @set_name.should_not be_nil
          @set_name[:params].length.should == 1
          @set_name[:params][0][:name].should == "name"
        end

        it "extracts processData with multiple parameters" do
          @process_data.should_not be_nil
          @process_data[:params].length.should == 2
        end

        it "detects throws clause on processData" do
          @process_data[:throws].should include("IOException")
        end

        it "extracts run method (from interface)" do
          @run.should_not be_nil
          @run[:tagname].should == :method
        end
      end
    end

  else
    it "skips integration tests (JavaParser JAR not available)" do
      pending("JavaParser JAR not found")
    end
  end

end
