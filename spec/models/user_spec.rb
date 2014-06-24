require 'spec_helper'

describe User do
  let(:user) {FactoryGirl.build(:user)}

  describe "valid user" do
    it "default should be valid" do
      user.should be_valid
    end
  end

  describe "topic" do
    before do
      user.save
    end

    it "default topic count is 0" do
      expect(user.topics_count).to eq(0)
    end

    it "topic count should add/decrease 1 after topic is created" do
      topic = FactoryGirl.create(:topic,user: user)
      topic.should be_valid
      user.reload
      expect(user.topics_count).to eq(1)
      topic.destroy
      user.reload
      expect(user.topics_count).to eq(0)
    end

  end
end