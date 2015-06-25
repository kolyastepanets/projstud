require 'rails_helper'

feature 'view questions', %q{
  all users can see
  any question
} do

  scenario 'view questions' do
    user = create(:user)
    questions = create_list(:question, 2)

    visit questions_path

    questions.each do |question|
      expect(page).to have_link question.title
    end
  end

end