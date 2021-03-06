require 'spec_helper'

module TerminalSymbolSpec
  class Foo < Treetop::Runtime::SyntaxNode
  end

  describe "a terminal symbol followed by a node class declaration and a block" do
    testing_expression "'foo' <TerminalSymbolSpec::Foo> { def a_method; end }"

    it "correctly parses matching input prefixes at various indices, returning an instance of the declared class that can respond to methods defined in the inline module" do
      parse "foo", :index => 0 do |result|
        result.should be_an_instance_of(Foo)
        result.should respond_to(:a_method)
        result.interval.should == (0...3)
        result.text_value.should == 'foo'
      end

      parse "xfoo", :index => 1 do |result|
        result.should be_an_instance_of(Foo)
        result.should respond_to(:a_method)
        result.interval.should == (1...4)
        result.text_value.should == 'foo'
      end
    
      parse "---foo", :index => 3 do |result|
        result.should be_an_instance_of(Foo)
        result.should respond_to(:a_method)
        result.interval.should == (3...6)
        result.text_value.should == 'foo'
      end
    end

    it "fails to parse nonmatching input at the index even if a match occurs later" do
      parse(" foo", :index =>  0) do |result|
        result.should be_nil
        parser.terminal_failures.size.should == 1
      end
    end
  end
end
