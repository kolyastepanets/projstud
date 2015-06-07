require 'rails_helper'

feature 'user sign in', %q{
  in order to be able to ask question
  as an user
  i want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'unregistered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password'
    expect("/").to eq root_path
  end

end