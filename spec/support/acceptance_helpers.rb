module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_out(user)
    click_on 'Log out'
  end

  def mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
         'provider' => 'facebook',
         'uid' => '123545',
         'info' => {
             'name' => 'mockuser',
             'email' => 'test@user.com'
         },
     })

    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
         'provider' => 'twitter',
         'uid' => '123456',
     })
  end
end