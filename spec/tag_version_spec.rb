require "jsduck/tag/version"
require "jsduck/doc/parser"

describe JsDuck::Tag::Version do

  def parse(str)
    parser = JsDuck::Doc::Parser.new
    parser.parse(str)
  end

  describe "@version tag parsing" do
    before do
      @doc = parse(<<-EOS)
        /**
         * Some documentation.
         * @version 1.0.0
         */
      EOS
    end

    it "detects @version tag" do
      @doc[:version].should == "1.0.0"
    end
  end

  describe "@version with complex version string" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @version 2.5.3-beta.1
         */
      EOS
    end

    it "captures the full version string" do
      @doc[:version].should == "2.5.3-beta.1"
    end
  end

  describe "@version with description" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @version 1.0 Initial release
         */
      EOS
    end

    it "captures version with additional text" do
      @doc[:version].should == "1.0 Initial release"
    end
  end

  describe "@version in class documentation" do
    it "stores version in doc hash" do
      tag = JsDuck::Tag::Version.new
      h = {}
      tags = [{:version => "3.2.1"}]

      tag.process_doc(h, tags, {})

      h[:version].should == "3.2.1"
    end
  end

  describe "#to_html" do
    it "generates HTML output" do
      tag = JsDuck::Tag::Version.new
      context = {:version => "1.5.0"}

      html = tag.to_html(context)

      html.should include("Version:")
      html.should include("1.5.0")
    end

    it "escapes HTML in version string" do
      tag = JsDuck::Tag::Version.new
      context = {:version => "1.0 <script>alert('xss')</script>"}

      html = tag.to_html(context)

      html.should_not include("<script>")
      html.should include("&lt;script&gt;")
    end
  end

end
