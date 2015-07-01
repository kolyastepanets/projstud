require 'rails_helper'

feature 'vote for answer', %q{
if user liked the answer
he can vote for answer
} do

  given!(:user) { create(:user) }
  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'unauthenticated user tries to vote the answer' do
    visit question_path(question)
      within '.answer' do
        expect(page).to_not have_link "Like"
      end
  end

  describe 'Authenticated user' do
    scenario 'can see link Like or Dislike' do
      sign_in(user1)
      visit question_path(question)

      within '.answer' do
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
      end
    end

    scenario 'as author of answer tries to vote answer', js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link "Like"
      expect(page).to_not have_link "Dislike"
    end

    scenario "tries to vote somebody's answer by clicking Like", js: true do
      sign_in(user1)
      visit question_path(question)
      within '.answer' do
        click_on 'Like'

        expect(page).to have_content "1"
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"
        expect(page).to have_link "Cancel Vote"
      end
    end

    scenario "tries to vote somebody's answer by clicking Dislike", js: true do
      sign_in(user1)
      visit question_path(question)
      within '.answer' do
        click_on 'Dislike'

        expect(page).to have_content "-1"
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"
        expect(page).to have_link "Cancel Vote"
      end
    end

    scenario "2 users vote to somebody's asnwer by clicking Like", js: true do
      sign_in(user1)
      visit question_path(question)
      within '.answer' do
        click_on 'Like'

        expect(page).to have_content "1"
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"
        expect(page).to have_link "Cancel Vote"
      end

      sign_out(user1)

      sign_in(user2)
      visit question_path(question)
      within '.answer' do
        click_on 'Like'

        expect(page).to have_content "2"
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"
        expect(page).to have_link "Cancel Vote"
      end
    end
  end
end