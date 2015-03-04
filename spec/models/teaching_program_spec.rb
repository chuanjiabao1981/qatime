require 'spec_helper'

describe TeachingProgram do
  before :each do
    @teachingProgram = TeachingProgram.new
  end

  describe "new" do
    it "normal" do
      @teachingProgram.grade    = "高三"
      @teachingProgram.name     = "test"
      @teachingProgram.subject  = "语文"
      @teachingProgram.content  = '{"chapters":["a","b"]}'
      @teachingProgram.category = "初中"
      @teachingProgram.should be_valid
    end

    it "json test" do
      @teachingProgram.content ='{"chapters":["a","b"]}'
      @teachingProgram.content["chapters"][0].should == "a"
    end
  end
end
