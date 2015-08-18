FactoryGirl.define do
  factory :vote do
    score 1
    association :votable, factory: :question
    association :user
  end

  factory :vote_down, class: 'Vote' do
      score -1
    end
end