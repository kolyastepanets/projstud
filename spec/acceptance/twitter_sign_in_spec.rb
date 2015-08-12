require 'rails_helper'

feature 'User sign in with Twitter', %q{
  As an unauthenticated user
  I want to be able to sign in with Twitter
} do

  describe "access page" do
    it "can sign in user with Twitter account" do
      clear_emails
      mock_auth_hash
      visit new_user_session_path

      click_on "Sign in with Twitter"
      fill_in 'Your email', with: 'test@example.com'
      click_on 'Send'

      open_email 'test@example.com'
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end
  end
end