require "jsduck/relations"
require "jsduck/type_parser"
require "jsduck/format/doc"
require "jsduck/class"
require "ostruct"

describe "JsDuck::TypeParser with Java types" do

  def parse(str)
    relations = JsDuck::Relations.new([], [
      "String",
      "Number",
      "Boolean",
      "Object",
    ])
    formatter = OpenStruct.new(:relations => relations)
    parser = JsDuck::TypeParser.new(formatter)
    parser.parse(str)
  end

  describe "Java primitive types" do
    it "matches int" do
      parse("int").should == true
    end

    it "matches long" do
      parse("long").should == true
    end

    it "matches double" do
      parse("double").should == true
    end

    it "matches float" do
      parse("float").should == true
    end

    it "matches short" do
      parse("short").should == true
    end

    it "matches byte" do
      parse("byte").should == true
    end

    it "matches char" do
      parse("char").should == true
    end

    it "matches boolean (shared with JS)" do
      parse("boolean").should == true
    end
  end

  describe "Java wrapper types" do
    it "matches Integer" do
      parse("Integer").should == true
    end

    it "matches Long" do
      parse("Long").should == true
    end

    it "matches Double" do
      parse("Double").should == true
    end

    it "matches Float" do
      parse("Float").should == true
    end

    it "matches Short" do
      parse("Short").should == true
    end

    it "matches Byte" do
      parse("Byte").should == true
    end

    it "matches Character" do
      parse("Character").should == true
    end

    it "matches Boolean" do
      parse("Boolean").should == true
    end
  end

  describe "Java common types" do
    it "matches String" do
      parse("String").should == true
    end

    it "matches Object" do
      parse("Object").should == true
    end

    it "matches Class" do
      parse("Class").should == true
    end

    it "matches Void" do
      parse("Void").should == true
    end

    it "matches void (lowercase)" do
      parse("void").should == true
    end
  end

  describe "Java arrays" do
    it "matches int[]" do
      parse("int[]").should == true
    end

    it "matches String[]" do
      parse("String[]").should == true
    end

    it "matches Integer[][]" do
      parse("Integer[][]").should == true
    end

    it "matches Object[]" do
      parse("Object[]").should == true
    end
  end

  describe "Mixed Java and JavaScript types" do
    it "matches int/String alternation" do
      parse("int/String").should == true
    end

    it "matches boolean/Boolean alternation" do
      parse("boolean/Boolean").should == true
    end

    it "matches Integer/number alternation" do
      parse("Integer/number").should == true
    end

    it "matches String/null alternation" do
      parse("String/null").should == true
    end
  end

  describe "Java types with modifiers" do
    it "matches nullable Integer" do
      parse("?Integer").should == true
    end

    it "matches non-nullable int" do
      parse("!int").should == true
    end

    it "matches varargs int..." do
      parse("int...").should == true
    end

    it "matches varargs String..." do
      parse("String...").should == true
    end
  end

  describe "Complex Java type expressions" do
    it "matches method with primitive params" do
      parse("function(int, double): String").should == true
    end

    it "matches method with wrapper types" do
      parse("function(Integer, Double): Boolean").should == true
    end

    it "matches method with mixed types" do
      parse("function(int, String, boolean): Object").should == true
    end

    it "matches method returning void" do
      parse("function(String): void").should == true
    end

    it "matches method with array params" do
      parse("function(int[], String[]): Object").should == true
    end

    it "matches method with optional params" do
      parse("function(int, String=): boolean").should == true
    end

    it "matches method with varargs" do
      parse("function(String, ...int)").should == true
    end
  end

  describe "Java and JavaScript type coexistence" do
    it "allows mixing int and number" do
      parse("int/number").should == true
    end

    it "allows mixing String (Java) and string (JS)" do
      parse("String/string").should == true
    end

    it "allows mixing Boolean (Java) and boolean (JS)" do
      parse("Boolean/boolean").should == true
    end

    it "works with undefined (JS only)" do
      parse("int/undefined").should == true
    end

    it "works with null (shared)" do
      parse("Integer/null").should == true
    end
  end

end
