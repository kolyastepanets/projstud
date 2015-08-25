require 'rails_helper'

RSpec.describe Answer, type: :model do
	it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

	it { should validate_presence_of :body }
	it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }

  describe '#notify' do
    let(:user) { create(:user) }
    let(:user1) { create(:user) }
    let!(:question) {create(:question, user: user1) }
    let(:answer) { create(:answer, question: question, user: user)}

    subject { build(:answer, question: question, user: user) }

    it 'after created question author should receive answer on email' do
      expect(AnswerNotificationsJob).to receive(:perform_later).with(subject).and_call_original
      subject.save!
    end
  end
end
