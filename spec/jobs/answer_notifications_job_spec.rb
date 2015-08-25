require 'rails_helper'

RSpec.describe AnswerNotificationsJob, type: :job do
  let(:question) { create(:question) }
  let(:author) { question.user }
  let(:subscribed_user) { create(:user) }
  let!(:subscription) { create(:subscription, question: question, user: subscribed_user) }
  let!(:not_subscribed_user) { create(:user) }
  let(:answer) { create(:answer, question: question, user: not_subscribed_user) }

  it 'should sends email to subscribers' do
    [author, subscribed_user].each do |subscriber|
      expect(AnswerMailer).to receive(:notify_about_answer).with(subscriber, answer).and_call_original
    end
    AnswerNotificationsJob.perform_now(answer)
  end
end
