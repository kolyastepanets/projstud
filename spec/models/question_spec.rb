require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:votes).dependent(:destroy) }
	it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should belong_to(:user) }

  it { should validate_presence_of :title }
	it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
	it { should validate_length_of(:title).is_at_most(50) }

  it { should accept_nested_attributes_for :attachments }

  describe 'subscription' do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it 'should subscribe author to his question after create' do
      expect { subject.save! }.to change(user.subscriptions, :count).by(1)
    end

    it 'should not subscribe after update' do
      subject.save!
      expect(subject).to_not receive(:subscribe_author)
      subject.touch
    end
  end
end
