class Answer < ActiveRecord::Base
	belongs_to :question, -> { order('created_at ASC')}
	validates :body, :question_id, presence: true
end
