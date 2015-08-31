require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Answer }
    it { should be_able_to :index, Search }

    it { should be_able_to :click, Question }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer2) { create(:answer, question: question, user: other_user) }
    let(:other_answer) { create(:answer, question: other_question, user: other_user) }
    let(:attachment) { create(:attachment, attachable: question) }
    let(:other_attachment) { create(:attachment,  attachable: other_question) }
    let(:vote1) { create(:vote, user: user, votable: other_question) }
    let(:vote2) { create(:vote, user: other_user, votable: other_question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Answer }

    it { should be_able_to :destroy, Question }
    it { should be_able_to :destroy, Answer }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other_user), user: user }
    it { should be_able_to :update, create(:answer, question: question, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, question: question, user: other_user), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }
    it { should be_able_to :destroy, create(:answer, question: question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: other_user), user: user }

    it { should be_able_to :click, Question }

    it { should be_able_to :mark_solution, answer, user: user }
    it { should_not be_able_to :mark_solution, other_answer, user: user }

    it { should be_able_to :destroy, attachment,  user: user}
    it { should_not be_able_to :destroy, other_attachment,  user: user}

    it { should be_able_to :vote_up, other_question, user: user}
    it { should be_able_to :vote_up, answer2, user: user}
    it { should be_able_to :vote_down, other_question, user: user}
    it { should be_able_to :vote_down, answer2, user: user}

    it do
      vote1
      should be_able_to :cancel_vote, other_question, user: user
    end

    it { should_not be_able_to :vote_up, question, user: user}
    it { should_not be_able_to :vote_up, answer, user: user}
    it { should_not be_able_to :vote_down, question, user: user}
    it { should_not be_able_to :vote_down, answer, user: user}

    it do
      vote2
      should_not be_able_to :cancel_vote, other_question, user: user
    end
  end
end