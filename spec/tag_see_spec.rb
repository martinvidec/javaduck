require "jsduck/tag/see"
require "jsduck/doc/parser"

describe JsDuck::Tag::See do

  def parse(str)
    parser = JsDuck::Doc::Parser.new
    parser.parse(str)
  end

  describe "@see tag parsing" do
    before do
      @doc = parse(<<-EOS)
        /**
         * Some documentation.
         * @see MyOtherClass
         */
      EOS
    end

    it "detects @see tag" do
      @doc[:see].should == ["MyOtherClass"]
    end
  end

  describe "multiple @see tags" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @see MyClass
         * @see #methodName()
         * @see java.util.List
         */
      EOS
    end

    it "captures all @see references" do
      @doc[:see].should == ["MyClass", "#methodName()", "java.util.List"]
    end

    it "stores them in array" do
      @doc[:see].should be_an(Array)
      @doc[:see].length.should == 3
    end
  end

  describe "@see with URL" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @see https://example.com/docs
         */
      EOS
    end

    it "captures URL reference" do
      @doc[:see].should == ["https://example.com/docs"]
    end
  end

  describe "@see with method reference" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @see #doSomething()
         */
      EOS
    end

    it "captures method reference with #" do
      @doc[:see].should == ["#doSomething()"]
    end
  end

  describe "#process_doc" do
    it "stores all references as array" do
      tag = JsDuck::Tag::See.new
      h = {}
      tags = [
        {:reference => "ClassA"},
        {:reference => "ClassB"},
        {:reference => "#method()"}
      ]

      tag.process_doc(h, tags, {})

      h[:see].should == ["ClassA", "ClassB", "#method()"]
    end
  end

  describe "#to_html" do
    it "generates HTML list with references" do
      tag = JsDuck::Tag::See.new
      context = {:see => ["MyClass", "#myMethod()"]}

      html = tag.to_html(context)

      html.should include("See also:")
      html.should include("MyClass")
      html.should include("#myMethod()")
      html.should include("<ul>")
      html.should include("<li>")
    end

    it "renders URLs as clickable links" do
      tag = JsDuck::Tag::See.new
      context = {:see => ["https://example.com/docs"]}

      html = tag.to_html(context)

      html.should include("<a href=\"https://example.com/docs\"")
      html.should include("target=\"_blank\"")
    end

    it "renders class references as plain text" do
      tag = JsDuck::Tag::See.new
      context = {:see => ["MyClass"]}

      html = tag.to_html(context)

      html.should include("MyClass")
      html.should_not include("<a href=")
    end

    it "escapes HTML in references" do
      tag = JsDuck::Tag::See.new
      context = {:see => ["<script>alert('xss')</script>"]}

      html = tag.to_html(context)

      html.should_not include("<script>")
      html.should include("&lt;script&gt;")
    end

    it "returns empty string when no @see tags" do
      tag = JsDuck::Tag::See.new
      context = {}

      html = tag.to_html(context)

      html.should == ""
    end

    it "returns empty string when @see array is empty" do
      tag = JsDuck::Tag::See.new
      context = {:see => []}

      html = tag.to_html(context)

      html.should == ""
    end
  end

  describe "tag configuration" do
    it "is marked as repeatable" do
      tag = JsDuck::Tag::See.new
      tag.repeatable.should == true
    end

    it "has correct pattern" do
      tag = JsDuck::Tag::See.new
      tag.pattern.should == "see"
    end

    it "has correct tagname" do
      tag = JsDuck::Tag::See.new
      tag.tagname.should == :see
    end
  end

end
