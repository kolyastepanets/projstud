shared_examples_for "Voting" do
  describe 'POST #vote_up' do
    before { sign_in(user2) }
    context 'non-owner of answer' do
      it 'changes the vote, score 1' do
        expect { post :vote_up, id: votable, format: :json }.to change(Vote, :count).by(1)
      end
    end
  end

  describe 'POST #vote_down' do
    before { sign_in(user2) }
    context 'non-owner of answer' do
      it 'changes the vote, score -1' do
        expect { post :vote_down, id: votable, format: :json }.to change(Vote, :count).by(1)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    before { sign_in(user2) }
    before { vote }
    context 'non-owner of answer' do
      it 'cancels the vote' do
        expect { delete :cancel_vote, id: votable, format: :json }.to change(Vote, :count).by(-1)
      end
    end
  end
end