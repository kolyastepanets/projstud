class Question < ActiveRecord::Base
	has_many :answers, -> { order('created_at DESC') }, dependent: :destroy
	validates :title, :body, presence: true
	validates :title, length: { maximum: 50 }
end
