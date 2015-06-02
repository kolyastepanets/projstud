require 'rails_helper'

RSpec.describe Answer, type: :model do
	it { should belong_to(:question).order('created_at ASC') }
	it { should validate_presence_of :body }
	it { should validate_presence_of :question_id }
end
