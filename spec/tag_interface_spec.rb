require "jsduck/tag/interface"
require "jsduck/doc/parser"

describe JsDuck::Tag::Interface do

  def parse(str)
    parser = JsDuck::Doc::Parser.new
    parser.parse(str)
  end

  describe "@interface tag parsing" do
    before do
      @doc = parse(<<-EOS)
        /**
         * A test interface.
         * @interface MyInterface
         */
      EOS
    end

    it "detects @interface tag" do
      @doc[:name].should == "MyInterface"
    end

    it "sets interface marker" do
      @doc[:interface].should == true
    end
  end

  describe "#to_html" do
    it "generates HTML for interface" do
      tag = JsDuck::Tag::Interface.new
      context = {:interface => true, :name => "TestInterface"}

      html = tag.to_html(context)

      html.should include("INTERFACE:")
      html.should include("Java interface")
      html.should include("interface-box")
    end

    it "returns empty array when not an interface" do
      tag = JsDuck::Tag::Interface.new
      context = {:interface => false}

      html = tag.to_html(context)

      html.should == []
    end

    it "returns empty array when interface key missing" do
      tag = JsDuck::Tag::Interface.new
      context = {}

      html = tag.to_html(context)

      html.should == []
    end
  end

  describe "tag configuration" do
    it "has correct pattern" do
      tag = JsDuck::Tag::Interface.new
      tag.pattern.should == "interface"
    end

    it "has correct tagname" do
      tag = JsDuck::Tag::Interface.new
      tag.tagname.should == :interface
    end

    it "has class icon" do
      tag = JsDuck::Tag::Interface.new
      tag.class_icon.should be_a(Hash)
      tag.class_icon[:small].should include("interface.png")
      tag.class_icon[:large].should include("interface-large.png")
      tag.class_icon[:redirect].should include("interface-redirect.png")
    end

    it "has correct priority" do
      tag = JsDuck::Tag::Interface.new
      tag.class_icon[:priority].should == JsDuck::Tag::Tag::PRIORITY_INTERFACE
    end

    it "has signature" do
      tag = JsDuck::Tag::Interface.new
      tag.signature.should be_a(Hash)
      tag.signature[:long].should == "interface"
      tag.signature[:short].should == "INT"
    end

    it "has CSS" do
      tag = JsDuck::Tag::Interface.new
      tag.css.should include("interface-box")
      tag.css.should include("signature .interface")
    end
  end

end
