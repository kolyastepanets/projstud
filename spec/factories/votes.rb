FactoryGirl.define do
  factory :vote do
    score 1
    association :votable, factory: :question
    association :user
  end
end