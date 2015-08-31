require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }

  it do
    create(:subscription)
    should validate_uniqueness_of(:question_id).scoped_to(:user_id)
  end
end