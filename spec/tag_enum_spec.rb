require "jsduck/tag/enum"
require "jsduck/doc/parser"

describe JsDuck::Tag::Enum do

  def parse(str)
    parser = JsDuck::Doc::Parser.new
    parser.parse(str)
  end

  describe "@enum tag parsing" do
    before do
      @doc = parse(<<-EOS)
        /**
         * A test enum.
         * @enum {String} Color
         */
      EOS
    end

    it "detects @enum tag" do
      @doc[:enum].should_not be_nil
      @doc[:enum][:type].should == "String"
    end

    it "sets class name" do
      @doc[:name].should == "Color"
    end
  end

  describe "#to_html" do
    it "generates HTML for enum" do
      tag = JsDuck::Tag::Enum.new
      context = {
        :enum => {:type => "String", :doc_only => false},
        :name => "Color"
      }

      html = tag.to_html(context)

      html.should include("ENUM:")
      html.should include("enumeration")
      html.should include("enum-box")
    end

    it "returns empty array when not an enum" do
      tag = JsDuck::Tag::Enum.new
      context = {}

      html = tag.to_html(context)

      html.should == nil
    end
  end

  describe "tag configuration" do
    it "has correct pattern" do
      tag = JsDuck::Tag::Enum.new
      tag.pattern.should == "enum"
    end

    it "has correct tagname" do
      tag = JsDuck::Tag::Enum.new
      tag.tagname.should == :enum
    end

    it "has class icon" do
      tag = JsDuck::Tag::Enum.new
      tag.class_icon.should be_a(Hash)
      tag.class_icon[:small].should include("enum.png")
      tag.class_icon[:large].should include("enum-large.png")
      tag.class_icon[:redirect].should include("enum-redirect.png")
    end

    it "has correct priority" do
      tag = JsDuck::Tag::Enum.new
      tag.class_icon[:priority].should == JsDuck::Tag::Tag::PRIORITY_ENUM
    end

    it "has signature" do
      tag = JsDuck::Tag::Enum.new
      tag.signature.should be_a(Hash)
      tag.signature[:long].should == "enum"
      tag.signature[:short].should == "ENUM"
    end

    it "has CSS" do
      tag = JsDuck::Tag::Enum.new
      tag.css.should include("enum-box")
      tag.css.should include("signature .enum")
    end
  end

end
