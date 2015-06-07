FactoryGirl.define do
  sequence :title do |n|
    "Text#{n}"
  end

  factory :question do
    title
    body "MyText"
    user

    trait :invalid do
      title nil
      body nil
    end
  end
end
