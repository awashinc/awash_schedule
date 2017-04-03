class AdminUsers::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = AdminUser.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?


      set_flash_message(:notice, :success, :kind => "Google")
      sign_in @user
      redirect_to root_path
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end 
  end 

  def failure
    redirect_to root_path
  end 

end
