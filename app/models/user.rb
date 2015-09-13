class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :skip_confirmation!

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy, as: :votable
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
    return authorization.user if authorization

    email = auth.info.try(:email)
    if email
      user = User.where(email: email).first
    else
      return nil
    end

    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      user = generate_user(email)
      user.skip_confirmation!
      user.save
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end

  def self.generate_user(email)
    password = Devise.friendly_token[0, 20]
    user = User.new(email: email, password: password, password_confirmation: password)
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end

   def subscribed?(question)
    Subscription.exists?(user: self, question: question)
  end
end