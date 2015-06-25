require 'rails_helper'

feature 'invalid question and answer', %q{
  user can not create question and answer
  with invalid data
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'invalid answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Your Answer', with: ''
    click_on 'Add answer'

    expect(page).to have_content "Body can't be blank"
    
  end
end