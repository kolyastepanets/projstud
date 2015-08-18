require 'rails_helper'

feature 'create comment', %q{
  in order to specify smth in question
  or ask additional info
  as an authenticated user
  i want to able to create comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'authenticated user creates comment', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'add a comment'
    fill_in 'Your Comment', with: 'Test content'
    click_on 'Add Comment'

    expect(page).to have_content 'Test content'
  end

  scenario 'comment with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'add a comment'
    fill_in 'Your Comment', with: ''
    click_on 'Add Comment'

    expect(page).to have_content "Content can't be blank"
  end

  scenario 'unautenticated user tries to create question' do
    visit question_path(question)

    expect(page).to_not have_link "add a comment"
  end
end