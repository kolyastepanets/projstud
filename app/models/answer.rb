class Answer < ActiveRecord::Base
  include Votable
  include Attachable

	belongs_to :question
  belongs_to :user
  has_many :comments, dependent: :destroy, as: :commentable

  accepts_nested_attributes_for :attachments, reject_if: proc { |attrib| attrib['file'].nil? }

	validates :body, :question_id, :user_id, presence: true

  default_scope { order('is_solution DESC, created_at') }

  after_create :notify

  def mark_solution
    transaction do
      question.answers.update_all(is_solution: false)
      update!(is_solution: true)
    end
  end

  private

    def notify
      AnswerNotificationsJob.perform_later(self)
    end
end