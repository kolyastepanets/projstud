require 'rails_helper'

feature 'invalid question and answer', %q{
  user can not create question and answer
  with invalid data
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'invalid question' do

    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'
    
    expect(page).to have_content "Title can't be blankBody can't be blank"
  end

  scenario 'invalid answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Add answer'
    
    expect(page).to have_content "Body can't be blank"
    
  end
end