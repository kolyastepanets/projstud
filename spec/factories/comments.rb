FactoryGirl.define do
  factory :comment do
    content "MyText"
    association :user

    trait :invalid do
      content nil
    end   
  end
end
