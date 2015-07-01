require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :user }
  it { should validate_presence_of :votable }

  it { should validate_inclusion_of(:score).in_array([-1, 1]) }
  it do
    create(:vote)
    should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type)
  end
end
