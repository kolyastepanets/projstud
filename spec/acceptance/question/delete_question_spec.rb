require 'rails_helper'

feature 'delete question' do

  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'authenticated user can delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content "Your question successfully deleted."
  end

  scenario 'unauthenticated can not delete your question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'authenticated user can not delete your answer' do
    sign_in(user1)
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end
end