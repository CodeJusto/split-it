class User < ActiveRecord::Base
  has_many :cart_roles
  has_many :carts, through: :cart_roles
  has_many :roles, through: :cart_roles
  has_many :payments
  has_many :refunds, through: :payments


  validates :name, presence: true
  # validates :email, presence: true, length: { minimum: 5 }
  validates :password, presence: true, length: { minimum: 8 }, on: :update, allow_blank: true

  has_secure_password


  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.password = SecureRandom.uuid.to_s
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

end
