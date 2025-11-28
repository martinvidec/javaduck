require "jsduck/tag/author"
require "jsduck/doc/parser"

describe JsDuck::Tag::Author do

  def parse(str)
    parser = JsDuck::Doc::Parser.new
    parser.parse(str)
  end

  describe "@author tag parsing" do
    before do
      @doc = parse(<<-EOS)
        /**
         * Some documentation.
         * @author John Doe
         */
      EOS
    end

    it "detects @author tag" do
      @doc[:author].should be_an(Array)
      @doc[:author].length.should == 1
    end

    it "parses author name" do
      @doc[:author][0][:name].should == "John Doe"
    end

    it "has no email when not specified" do
      @doc[:author][0][:email].should be_nil
    end
  end

  describe "@author with email" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @author Jane Smith <jane@example.com>
         */
      EOS
    end

    it "parses author name" do
      @doc[:author][0][:name].should == "Jane Smith"
    end

    it "parses author email" do
      @doc[:author][0][:email].should == "jane@example.com"
    end
  end

  describe "multiple @author tags" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @author John Doe
         * @author Jane Smith <jane@example.com>
         * @author Bob Jones <bob@example.com>
         */
      EOS
    end

    it "captures all authors" do
      @doc[:author].length.should == 3
    end

    it "stores them in order" do
      @doc[:author][0][:name].should == "John Doe"
      @doc[:author][1][:name].should == "Jane Smith"
      @doc[:author][2][:name].should == "Bob Jones"
    end

    it "captures emails where present" do
      @doc[:author][0][:email].should be_nil
      @doc[:author][1][:email].should == "jane@example.com"
      @doc[:author][2][:email].should == "bob@example.com"
    end
  end

  describe "#to_html" do
    it "generates HTML for single author without email" do
      tag = JsDuck::Tag::Author.new
      context = {:author => [{:name => "John Doe", :email => nil}]}

      html = tag.to_html(context)

      html.should include("Author:")
      html.should include("John Doe")
      html.should include("<ul>")
      html.should include("<li>")
    end

    it "generates HTML for single author with email" do
      tag = JsDuck::Tag::Author.new
      context = {:author => [{:name => "Jane Smith", :email => "jane@example.com"}]}

      html = tag.to_html(context)

      html.should include("Author:")
      html.should include("Jane Smith")
      html.should include("&lt;jane@example.com&gt;")
    end

    it "uses plural 'Authors:' for multiple authors" do
      tag = JsDuck::Tag::Author.new
      context = {
        :author => [
          {:name => "John Doe", :email => nil},
          {:name => "Jane Smith", :email => "jane@example.com"}
        ]
      }

      html = tag.to_html(context)

      html.should include("Authors:")
      html.should include("John Doe")
      html.should include("Jane Smith")
    end

    it "escapes HTML in author names" do
      tag = JsDuck::Tag::Author.new
      context = {:author => [{:name => "<script>alert('xss')</script>", :email => nil}]}

      html = tag.to_html(context)

      html.should_not include("<script>")
      html.should include("&lt;script&gt;")
    end

    it "escapes HTML in emails" do
      tag = JsDuck::Tag::Author.new
      context = {:author => [{:name => "Test", :email => "<script>"}]}

      html = tag.to_html(context)

      html.should include("&lt;script&gt;")
    end

    it "returns empty string when no authors" do
      tag = JsDuck::Tag::Author.new
      context = {}

      html = tag.to_html(context)

      html.should == ""
    end

    it "returns empty string when author array is empty" do
      tag = JsDuck::Tag::Author.new
      context = {:author => []}

      html = tag.to_html(context)

      html.should == ""
    end
  end

  describe "tag configuration" do
    it "is marked as repeatable" do
      tag = JsDuck::Tag::Author.new
      tag.repeatable.should == true
    end

    it "has correct pattern" do
      tag = JsDuck::Tag::Author.new
      tag.pattern.should == "author"
    end

    it "has correct tagname" do
      tag = JsDuck::Tag::Author.new
      tag.tagname.should == :author
    end
  end

end
