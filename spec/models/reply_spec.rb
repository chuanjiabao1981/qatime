require 'spec_helper'

describe Reply do
  let(:user) {FactoryGirl.build(:user)}
  let(:reply_user) {FactoryGirl.build(:user)}
  let(:topic) { user.topics.build(user_id: user.id) }
  let(:reply) { reply_user.replies.build(topic_id: topic.id) }

  subject { reply }

  it { should be_valid }
  it { should respond_to( :user_id ) }
  it { should respond_to( :topic_id ) }
end