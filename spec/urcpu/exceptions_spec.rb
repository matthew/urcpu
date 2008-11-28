require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

def urcpu_exceptions
  UrCPU.constants.sort.map do |constant|
    eval "UrCPU::#{constant}"
  end.select do |klass|
    klass < Exception
  end
end

describe "UrCPU Exceptions" do
  urcpu_exceptions.each do |klass|
    it "#{klass} should be a kind of UrCPU::Error" do
      lambda { raise klass, "test error" }.should raise_error(UrCPU::Error)
    end

    it "#{klass} should be a kind of StandardError" do
      lambda { raise klass, "test error" }.should raise_error(StandardError)
      (raise klass, "test error" rescue true).should be_true
    end
  end
end