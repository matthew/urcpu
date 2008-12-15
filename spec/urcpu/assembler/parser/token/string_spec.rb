require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Token::String do
  describe "#match" do
    before do
      @token = UrCPU::Assembler::Parser::Token::String.new(:imm)
    end
    
    it "matches a normal string" do
      @token.match('"cows are good"').should == ["cows are good"]
    end

    it "matches the empty string" do
      @token.match('""').should == [""]
    end

    it "matches a string containing an escape character" do
      @token.match('"do not use \t"').should == ["do not use \t"]
      @token.match('"do not use \n"').should == ["do not use \n"]
    end

    it "matches a string containing an escaped quote" do
      @token.match('"i \"like\" food"').should == ["i \"like\" food"]
    end

    it "doesn't match with an unbalanced quote" do
      @token.match('"cows').should be_nil
    end

    it "doesn't match with an unbalanced quote containing an escaped quote" do
      @token.match('"i \"like\" food').should be_nil
    end
  end
end