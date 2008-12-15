require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Result::Discard do
  describe "#==" do
    it "thinks all comments are the same" do
      klass = UrCPU::Assembler::Parser::Result::Discard
      comment1 = klass.new([])
      comment2 = klass.new(nil)
      comment1.should_not be_eql(comment2)
      comment1.should == comment2
    end

    it "doesn't equate a comment to a non-comment" do
      klass = UrCPU::Assembler::Parser::Result::Discard
      comment = klass.new([])
      comment.should_not == Object.new
    end
  end
end