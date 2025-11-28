require "jsduck/tag/since"
require "jsduck/doc/parser"

describe JsDuck::Tag::Since do

  def parse(str)
    parser = JsDuck::Doc::Parser.new
    parser.parse(str)
  end

  describe "@since tag parsing" do
    before do
      @doc = parse(<<-EOS)
        /**
         * Some documentation.
         * @since 1.0
         */
      EOS
    end

    it "detects @since tag" do
      @doc[:since].should == "1.0"
    end
  end

  describe "@since with version string" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @since 2.5.3
         */
      EOS
    end

    it "captures the version string" do
      @doc[:since].should == "2.5.3"
    end
  end

  describe "@since with date" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @since 2025-01-15
         */
      EOS
    end

    it "captures the date string" do
      @doc[:since].should == "2025-01-15"
    end
  end

  describe "@since with description" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @since 3.0 Major refactoring
         */
      EOS
    end

    it "captures version with additional text" do
      @doc[:since].should == "3.0 Major refactoring"
    end
  end

  describe "#process_doc" do
    it "stores version string" do
      tag = JsDuck::Tag::Since.new
      h = {}
      tags = [{:version => "1.5.0"}]

      tag.process_doc(h, tags, {})

      h[:since].should == "1.5.0"
    end
  end

  describe "#to_html" do
    it "generates HTML output" do
      tag = JsDuck::Tag::Since.new
      context = {:since => "2.0.0"}

      html = tag.to_html(context)

      html.should include("Available since:")
      html.should include("2.0.0")
    end

    it "escapes HTML in version string" do
      tag = JsDuck::Tag::Since.new
      context = {:since => "1.0 <script>alert('xss')</script>"}

      html = tag.to_html(context)

      html.should_not include("<script>")
      html.should include("&lt;script&gt;")
    end

    it "renders date strings" do
      tag = JsDuck::Tag::Since.new
      context = {:since => "2025-01-15"}

      html = tag.to_html(context)

      html.should include("2025-01-15")
    end

    it "renders with description" do
      tag = JsDuck::Tag::Since.new
      context = {:since => "3.0 Major release"}

      html = tag.to_html(context)

      html.should include("3.0 Major release")
    end
  end

  describe "tag configuration" do
    it "is not repeatable" do
      tag = JsDuck::Tag::Since.new
      tag.repeatable.should be_nil
    end

    it "has correct pattern" do
      tag = JsDuck::Tag::Since.new
      tag.pattern.should == "since"
    end

    it "has correct tagname" do
      tag = JsDuck::Tag::Since.new
      tag.tagname.should == :since
    end
  end

end
