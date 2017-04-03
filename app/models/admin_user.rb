class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = AdminUser.where(:email => data["email"]).first

    unless user
       user = AdminUser.create(username: data["name"], \
                        email: data["email"],
                        password: Devise.friendly_token[0,20],
                        uid: access_token["uid"]
                        )
       user.access_key = access_token["credentials"]["token"] if access_token["credentials"].present? && access_token["credentials"]["token"].present?
       user.refresh_token  = access_token["credentials"]["refresh_token"] if access_token["credentials"].present? && access_token["credentials"]["refresh_token"].present?
       user.save
    end

    user
  end
end
