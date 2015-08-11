require 'rails_helper'

feature 'user creates answer', %q{
  visit any question
  only authenticated user
  can answer to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'authenticated user creates answer to @question', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your Answer', with: 'answer for question'
    click_on 'Add answer'

    expect(page).to have_content 'answer for question'
  end

  scenario 'unauthenticated user tries to create answer to @question' do
    visit question_path(question)
    click_on 'Add answer'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

end