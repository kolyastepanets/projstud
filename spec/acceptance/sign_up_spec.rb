require 'rails_helper'

feature 'user can register' do

  scenario 'not signed in and not signed up user tries to sign up' do
    
    visit root_path
    click_on 'Sign up now'
    fill_in 'Email', with: "example@test.com"
    fill_in 'Password', with: "12345678"
    fill_in 'Password confirmation', with: "12345678"
    click_on 'Sign up'

    expect(page).to have_content "Welcome! You have signed up successfully."

  end

  # scenario 'registration false' do
  # end

end