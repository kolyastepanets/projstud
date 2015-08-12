require 'rails_helper'

feature 'User sign in with Facebook', %q{
  As an unauthenticated user
  I want to be able to sign in with Facebook
} do

  describe "access page" do
    it "can sign in user with Facebook account" do
      mock_auth_hash

      visit new_user_session_path
      click_on "Sign in with Facebook"

      open_email 'test@user.com'
      current_email.click_link 'Confirm my account'

      visit new_user_session_path
      click_on "Sign in with Facebook"

      expect(page).to have_content("test@user.com")
      expect(page).to have_content("Successfully authenticated from Facebook account.")
      expect(page).to have_content("Log out")
    end
  end
end