require 'rails_helper'

feature 'invalid question', %q{
  user can not create question
  with invalid data
} do

  given(:user) { create(:user) }

  scenario 'invalid question', js: true do

    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end
end