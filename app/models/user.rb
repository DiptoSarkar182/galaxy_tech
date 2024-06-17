class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable

  def admin?
    is_admin
  end

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :product_rating_and_reviews, dependent: :destroy
  has_many :add_to_wish_lists
  has_many :products, through: :add_to_wish_lists

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      if auth.provider == 'google_oauth2'
        user.full_name = auth.info.name
      end
      if user.new_record?
        user.save!
        WelcomeUserMailer.with(user: user).welcome_email.deliver_later
      end
    end
  end

end
