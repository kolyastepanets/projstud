class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    end
  end

  def twitter
    redirect new_user_session_path if request.env['omniauth.auth'].nil?
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user and @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
    else
      @user = User.new
      session[:auth_provider] = request.env['omniauth.auth'].provider
      session[:auth_uid] = request.env['omniauth.auth'].uid
      render 'omniauth_callbacks/email_confirmation'
    end
  end

  def email_confirmation
    @user = User.generate_user(user_params[:email])
    @user.authorizations.build(provider: session[:auth_provider], uid: session[:auth_uid])
    @user.save
    if @user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
    end
  end

  private

    def user_params
      params.require(:user).permit(:email)
    end
end