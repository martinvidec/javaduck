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

  describe "Java Generics (native syntax)" do
    # Helper for generics tests with custom relations
    def parse_generics(str)
      relations = JsDuck::Relations.new([], [
        "List",
        "Map",
        "Set",
        "ArrayList",
        "HashMap",
        "String",
        "Number",
        "Object",
      ])
      formatter = OpenStruct.new(:relations => relations)
      parser = JsDuck::TypeParser.new(formatter)
      parser.parse(str)
    end

    it "matches List<String>" do
      parse_generics("List<String>").should == true
    end

    it "matches Map<String,Number>" do
      parse_generics("Map<String,Number>").should == true
    end

    it "matches Set<Object>" do
      parse_generics("Set<Object>").should == true
    end

    it "matches nested generics List<List<String>>" do
      parse_generics("List<List<String>>").should == true
    end

    it "matches ArrayList<String>" do
      parse_generics("ArrayList<String>").should == true
    end

    it "matches HashMap<String,Object>" do
      parse_generics("HashMap<String,Object>").should == true
    end

    it "matches with primitive types List<int>" do
      parse_generics("List<int>").should == true
    end

    it "matches with multiple type params Map<String,List<Integer>>" do
      parse_generics("Map<String,List<Integer>>").should == true
    end

    it "still supports Closure Compiler syntax List.<String>" do
      parse_generics("List.<String>").should == true
    end

    it "matches List<String>[]" do
      parse_generics("List<String>[]").should == true
    end

    it "matches ?List<String> (nullable generic)" do
      parse_generics("?List<String>").should == true
    end

    it "matches List<String>... (varargs generic)" do
      parse_generics("List<String>...").should == true
    end

    it "matches function returning generic: function(): List<String>" do
      parse_generics("function(): List<String>").should == true
    end

    it "matches function with generic param: function(List<String>): void" do
      parse_generics("function(List<String>): void").should == true
    end

    it "matches complex function: function(Map<String,List<Integer>>): Set<Object>" do
      parse_generics("function(Map<String,List<Integer>>): Set<Object>").should == true
    end
  end

  describe "Java fully-qualified types (FQN)" do
    def parse_fqn(str)
      relations = JsDuck::Relations.new([], [
        "java.util.List",
        "java.util.Map",
        "java.lang.String",
        "java.lang.Object",
        "com.example.MyClass",
      ])
      formatter = OpenStruct.new(:relations => relations)
      parser = JsDuck::TypeParser.new(formatter)
      parser.parse(str)
    end

    it "matches java.util.List" do
      parse_fqn("java.util.List").should == true
    end

    it "matches java.util.Map" do
      parse_fqn("java.util.Map").should == true
    end

    it "matches java.lang.String" do
      parse_fqn("java.lang.String").should == true
    end

    it "matches com.example.MyClass" do
      parse_fqn("com.example.MyClass").should == true
    end

    it "matches FQN with generics java.util.List<String>" do
      parse_fqn("java.util.List<String>").should == true
    end

    it "matches FQN with multiple generics java.util.Map<String,Object>" do
      parse_fqn("java.util.Map<String,Object>").should == true
    end

    it "matches nested FQN generics java.util.List<java.lang.String>" do
      parse_fqn("java.util.List<java.lang.String>").should == true
    end

    it "matches FQN arrays java.lang.String[]" do
      parse_fqn("java.lang.String[]").should == true
    end

    it "matches FQN generic arrays java.util.List<String>[]" do
      parse_fqn("java.util.List<String>[]").should == true
    end

    it "matches function with FQN: function(java.util.List): void" do
      parse_fqn("function(java.util.List): void").should == true
    end

    it "matches function with FQN generics: function(java.util.Map<String,Object>): java.lang.String" do
      parse_fqn("function(java.util.Map<String,Object>): java.lang.String").should == true
    end
  end

end
