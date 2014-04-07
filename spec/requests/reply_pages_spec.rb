require 'spec_helper'

describe "reply pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:topic_author) { FactoryGirl.build(:user) }

  before {
    user.save
    topic_author.save
  }

  before { sign_in user }
  let (:topic) {FactoryGirl.create(:topic, user: topic_author)}
  before {
    topic.save
  }

  describe "reply creation" do
    before { visit topic_path(topic) }
    describe "with valid information" do

      before { fill_in 'reply_content', with: "first test" }
      it "should create a reply" do
        expect { click_button "Post_Reply" }.to change(Reply, :count).by(1)
      end
    end
  end
end