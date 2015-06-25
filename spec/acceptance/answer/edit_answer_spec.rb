require 'rails_helper'

feature 'edit answer', %q{
user can edit his created answer
to correct smth
} do

  given!(:user) { create(:user) }
  given!(:user1){ create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'unauthenticated user tries to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    scenario 'can see link Edit' do
      sign_in(user)
      visit question_path(question)
      within '.answer' do
        expect(page).to have_link "Edit"
      end
    end

    scenario 'tries to edit his answer' do
      sign_in(user)
      visit question_path(question)
      within '.answer' do
        click_on 'Edit'
        fill_in 'Edit Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "tries edit somebody's answer" do
      sign_in(user1)
      visit question_path(question)
      within '.answer' do
        expect(page).to_not have_link "Edit"
      end
    end
  end
end