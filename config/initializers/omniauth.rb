#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :google_oauth2, ENV["GOOGLE_API_CLIENT_ID"], ENV["GOOGLE_API_SECRET"],
#   {scope: "email, profile, plus.me, https://www.googleapis.com/auth/calendar",
#    :provider_ignores_state => true}
#end

OmniAuth.config.full_host = Rails.env.production? ? 'https://admin.awash.co.kr' : 'https://fe28203d.ngrok.io'
