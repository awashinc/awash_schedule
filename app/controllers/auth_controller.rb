class AuthController < ApplicationController
  def index

    cal = Google::Calendar.new(client_id: ENV['GOOGLE_API_CLIENT_ID'],
       :client_secret => ENV['GOOGLE_API_SECRET'],
       :calendar      => ENV['GOOGLE_CALENDAR_ID'],
       :redirect_url  => "#{OmniAuth.config.full_host}/admin_users/auth/google_oauth2/callback"
      )


     if AdminUser.where(email: cal.id).blank?
       res = cal.login_with_auth_code(params[:code])
       @admin_user = AdminUser.new(email: cal.id, access_key: cal.access_token, refresh_token: cal.refresh_token ).save
     else
       @admin_user = AdminUser.where(email: cal.id).first
       cal.login_with_refresh_token(@admin_user.refresh_token)
     end
=begin
    client = Signet::OAuth2::Client.new({
       client_id: "891105199825-5bsgp4mnc0fijqhphtpi97f0k506b8os.apps.googleusercontent.com",
       client_secret: "kamXbuZYolf-34PrFk-cRJlH",
            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
             redirect_uri: "http://2de588a4.ngrok.io/callback",
             code: params[:code] ,
             scope: ["https://www.googleapis.com/auth/calendar"],
             authorization_uri: "https://accounts.google.com/o/oauth2/auth"
    })
    res = client.fetch_access_token!


    cal1 = cal.dup
    cal1.connection.client = client
=end

  end

  def new 

    cal = Google::Calendar.new(client_id: ENV['GOOGLE_API_CLIENT_ID'],
       :client_secret => ENV['GOOGLE_API_SECRET'],
       :calendar      => ENV['GOOGLE_CALENDAR_ID'],
       :redirect_url  => "http://4c7a2ee8.ngrok.io/callback" # this is what Google uses for 'applications'
     ) 
    redirect_to cal.authorize_url.to_s
  end

end
