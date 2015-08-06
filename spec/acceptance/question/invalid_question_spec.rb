require 'rails_helper'

feature 'invalid question and answer', %q{
  user can not create question and answer
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
    
    expect(page).to have_content "Try again"
  end
end