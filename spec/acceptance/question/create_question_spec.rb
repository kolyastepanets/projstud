require 'rails_helper'

feature 'create question', %q{
  in order to get answer from community
  as an authenticated user
  i want to able to ask question
} do 

  given(:user) { create(:user) }

  scenario 'authenticated user creates question', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'
    
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'

  end

  scenario 'unautenticated user tries to create question' do
    visit questions_path
    click_on 'Ask Question'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end