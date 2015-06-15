require 'rails_helper'

feature 'edit question', %q{
user can edit his created question
to correct smth
} do

  given!(:user) { create(:user) }
  given!(:user1){ create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'unauthenticated user tries to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    scenario 'as author can see link Edit' do
      sign_in(user)
      visit question_path(question)
      within '.question' do
        expect(page).to have_link "Edit"
      end
    end

    scenario 'as author tries to edit his question' do
      sign_in(user)
      visit question_path(question)
      within '.question' do
        click_on 'Edit'
        fill_in 'Edit Title', with: 'edited title'
        fill_in 'Edit Question Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited body'
        expect(page).to have_content 'edited title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "tries edit somebody's question" do
      sign_in(user1)
      visit question_path(question)
      expect(page).to_not have_link "Edit"
    end
  end
end