require 'rails_helper'

feature 'view all questions and answers', %q{
  all user can visit any question
  and see all answers to this question
} do

  scenario 'view question and answers' do
    user = create(:user)
    question = create(:question, user: user)
    answer = create(:answer, question: question, user: user)
    answer1 = create(:answer, question: question, user: user)

    visit question_path(question)

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end