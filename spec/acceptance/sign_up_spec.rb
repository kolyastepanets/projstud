require 'rails_helper'

feature 'user can register' do

  scenario 'not signed in and not signed up user tries to sign up' do
    visit root_path
    click_on 'Sign up now'
    fill_in 'Email', with: "example@test.com"
    fill_in 'Password', with: "12345678"
    fill_in 'Password confirmation', with: "12345678"
    click_on 'Sign up'

    open_email 'example@test.com'
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Login'
    fill_in 'Email', with: "example@test.com"
    fill_in 'Password', with: "12345678"
    click_on 'Log in'

    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "example@test.com"
  end

  # scenario 'registration false' do
  # end

end