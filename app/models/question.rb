class Question < ActiveRecord::Base
  include Votable
  include Attachable

	has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :subscriptions, dependent: :destroy

  belongs_to :user

  validates :title, :body, :user_id, presence: true
	validates :title, length: { maximum: 50 }

  default_scope { order('created_at DESC') }

  after_create :subscribe_author

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def subscribe_author
    subscriptions.create(user: user)
  end
end