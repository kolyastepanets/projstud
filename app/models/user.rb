class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy, as: :votable 

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
