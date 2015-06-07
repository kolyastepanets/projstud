require 'rails_helper'

feature 'user signout', %q{
  user can sign out
}do

  given(:user) { create(:user) }

  scenario 'user sign out' do
    sign_in(user)
  
    click_on 'Logout'
    expect(page).to have_content "Signed out successfully."

  end
end