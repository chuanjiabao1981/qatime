require 'spec_helper'

describe Reply do
  let(:user) {FactoryGirl.build(:user)}
  let(:reply_user) {FactoryGirl.build(:user)}

  before do
    user.save
    reply_user.save
  end

  let (:topic) {FactoryGirl.create(:topic, user: user)}
  let(:reply) { reply_user.replies.build(topic_id: topic.id, body:"test") }

  subject { reply }

  it { should be_valid}
  it { should respond_to( :user_id ) }
  it { should respond_to( :topic_id ) }
  it { should respond_to( :body ) }

  describe "basic test" do
    its(:user_id) { should eq reply_user.id;}
    its(:topic_id) { should eq topic.id }
  end

  describe "when reply id is not present" do
    before { reply.user_id = nil }
    it { should_not be_valid }
  end

  describe "when topic id is not present" do
    before { reply.topic_id = nil }
    it { should_not be_valid }
  end

  describe "when body is not present" do
    before { reply.body = nil }
    it { should_not be_valid }
  end
end