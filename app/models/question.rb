class Question < ActiveRecord::Base
	has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable

  belongs_to :user
	
  validates :title, :body, :user_id, presence: true
	validates :title, length: { maximum: 50 }

  default_scope { order('created_at DESC') }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
