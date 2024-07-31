class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable

  validates :full_name, presence: true, length: { in: 3..100 }
  validate :name_must_be_alphabetic

  before_validation :format_full_name

  def admin?
    is_admin
  end

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :product_rating_and_reviews, dependent: :destroy
  has_many :add_to_wish_lists, dependent: :destroy
  has_many :products, through: :add_to_wish_lists

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name if auth.provider == 'google_oauth2'
    end

    is_new_user = user.new_record?
    user.save! if is_new_user
    WelcomeUserMailer.with(user: user).welcome_email.deliver_later if is_new_user

    return user, is_new_user
  end

  private
  def format_full_name
    if full_name.present?
      self.full_name = full_name.squish.split.map { |word| word.capitalize }.join(' ')
    end
  end

  def name_must_be_alphabetic
    unless full_name =~ /\A[a-zA-Z\s]+\z/
      errors.add(:full_name, "must contain only alphabetic characters(a-zA-Z)")
    end
  end

end
