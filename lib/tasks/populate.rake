namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    require 'populator'

    Question.delete_all

    Question.populate 300 do |question|
      question.title = Populator.words(1..3)
      question.body = Populator.words(4..6)
    end
  end
end