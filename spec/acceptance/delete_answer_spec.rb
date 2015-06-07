require 'rails_helper'

feature 'delete answer' do

  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'authenticated user can delete his answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to have_content "Your answer successfully deleted."
  end

  scenario 'unauthenticated user can not delete someone answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'authenticated user tries to delete another answer' do
    sign_in(user1)
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end
end