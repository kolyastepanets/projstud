class Answer < ActiveRecord::Base
	belongs_to :question
  belongs_to :user

	validates :body, :question_id, :user_id, presence: true
  
  default_scope { order('is_solution DESC, created_at') }

  def mark_solution
    transaction do
      question.answers.update_all(is_solution: false)
      update!(is_solution: true)
    end
  end
end
