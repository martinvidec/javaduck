require "jsduck/params_merger"

describe JsDuck::ParamsMerger do

  describe ".merge_types_from_code" do

    it "merges types from code params into typeless doc params (Javadoc style)" do
      doc_params = [
        {:name => "name", :doc => "the name"},
        {:name => "age", :doc => "the age"}
      ]
      code_params = [
        {:name => "name", :type => "String"},
        {:name => "age", :type => "int"}
      ]

      JsDuck::ParamsMerger.merge_types_from_code(doc_params, code_params)

      doc_params[0][:type].should == "String"
      doc_params[1][:type].should == "int"
    end

    it "preserves existing types in doc params (JSDoc style)" do
      doc_params = [
        {:name => "name", :type => "String", :doc => "the name"},
        {:name => "age", :type => "Number", :doc => "the age"}
      ]
      code_params = [
        {:name => "name", :type => "java.lang.String"},
        {:name => "age", :type => "int"}
      ]

      JsDuck::ParamsMerger.merge_types_from_code(doc_params, code_params)

      # Should keep JSDoc types, not overwrite with code types
      doc_params[0][:type].should == "String"
      doc_params[1][:type].should == "Number"
    end

    it "handles mismatched parameter names gracefully" do
      doc_params = [
        {:name => "username", :doc => "the username"}
      ]
      code_params = [
        {:name => "name", :type => "String"}
      ]

      JsDuck::ParamsMerger.merge_types_from_code(doc_params, code_params)

      # Should not have type since names don't match
      doc_params[0][:type].should be_nil
    end

    it "handles empty code params" do
      doc_params = [
        {:name => "name", :doc => "the name"}
      ]
      code_params = []

      JsDuck::ParamsMerger.merge_types_from_code(doc_params, code_params)

      doc_params[0][:type].should be_nil
    end

    it "merges only matching params by name" do
      doc_params = [
        {:name => "name", :doc => "the name"},
        {:name => "age", :doc => "the age"},
        {:name => "city", :doc => "the city"}
      ]
      code_params = [
        {:name => "name", :type => "String"},
        {:name => "city", :type => "String"}
      ]

      JsDuck::ParamsMerger.merge_types_from_code(doc_params, code_params)

      doc_params[0][:type].should == "String"
      doc_params[1][:type].should be_nil  # no match
      doc_params[2][:type].should == "String"
    end

  end

  describe ".merge" do

    before do
      @file = {:filename => "test.java", :linenr => 1}
    end

    it "defaults to Object for params without types" do
      h = {:params => [{:name => "test"}], :files => [@file]}
      docs = {:params => [{:name => "test"}]}
      code = {:params => []}

      JsDuck::ParamsMerger.merge(h, docs, code)

      h[:params][0][:type].should == "Object"
    end

    it "uses types from code for Javadoc-style params" do
      h = {:params => [{:name => "name"}], :files => [@file]}
      docs = {:params => [{:name => "name"}]}
      code = {:params => [{:name => "name", :type => "String"}]}

      JsDuck::ParamsMerger.merge(h, docs, code)

      h[:params][0][:type].should == "String"
    end

    it "preserves JSDoc-style types over code types" do
      h = {:params => [{:name => "name", :type => "String"}], :files => [@file]}
      docs = {:params => [{:name => "name", :type => "String"}]}
      code = {:params => [{:name => "name", :type => "java.lang.String"}]}

      JsDuck::ParamsMerger.merge(h, docs, code)

      h[:params][0][:type].should == "String"
    end

  end

end
