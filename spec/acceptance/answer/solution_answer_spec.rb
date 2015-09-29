require 'rails_helper'

feature 'user choose solution answer', %q{
visit any question
only authenticated user
and only author of question
can mark answer as the solution answer
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user1) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user2) }
  given(:solution_answer) { create(:answer, is_solution: true, question: question, user: user2) }

  scenario 'Unathenticated user tries to choose best answer' do
    visit question_path(question)
    expect(page).to_not have_link "Mark as solution"
  end

  describe 'Authenticated user', js: true do

    scenario 'non author of question can not choose best answer' do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link "Mark as solution"
    end

    scenario 'author of question choose the solution answer', js: true do
      sign_in(user1)
      visit question_path(question)

      within("#answer-#{answers[3].id}") do
        click_on 'Mark as solution'
        expect(page).to have_css('div#accepted-answer')
        expect(page).to_not have_content 'Mark as solution'
      end
    end

    scenario 'author of question choose another answer as solution' do
      sign_in(user1)
      visit question_path(question)

      within("#answer-#{answers[3].id}") do
        click_on 'Mark as solution'
        expect(page).to have_css('div#accepted-answer')
        expect(page).to_not have_content 'Mark as solution'
      end

      within("#answer-#{answers[4].id}") do
        click_on 'Mark as solution'
        expect(page).to have_css('div#accepted-answer')
        expect(page).to_not have_content 'Mark as solution'
      end
    end

    scenario 'solution answer is the first answer' do
      sign_in(user1)
      visit question_path(question)

     within("#answer-#{answers[3].id}") do
        click_on 'Mark as solution'
        expect(page).to have_css('div#accepted-answer')
        expect(page).to_not have_content 'Mark as solution'
      end

     within("#answer-#{answers[4].id}") do
        click_on 'Mark as solution'
        expect(page).to have_css('div#accepted-answer')
        expect(page).to_not have_content 'Mark as solution'
      end

      within '.answer:first-child' do
        expect(page).to have_css('div#accepted-answer')
        expect(page).to_not have_content 'Mark as solution'
      end

      within("#answer-#{answers[3].id}") do
        click_on 'Mark as solution'
        expect(page).to_not have_css('div#accepted-answer')
        expect(page).to have_content 'Mark as solution'
      end
    end

    scenario 'question has already solution answer' do
      solution_answer
      sign_in(user1)
      visit question_path(question)

      within "#answer-#{solution_answer.id}" do
        expect(page).to_not have_content 'Mark as solution'
        expect(page).to have_css('div#accepted-answer')
      end
    end
  end
end