class AnswerMailer < ApplicationMailer
  def notify_about_answer(user, answer)
    @answer = answer
    mail to: user.email
  end
end