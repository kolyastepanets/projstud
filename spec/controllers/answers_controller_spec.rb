require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid atrributes' do
      it 'saves new answer with question_id' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(Answer, :count).by(1)
      end

      it 'assigns answer to question_id' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        answer = assigns(:answer)
        expect(answer.user_id).to eq user.id
        expect(answer.question_id).to eq question.id
      end

      it 'redirects to show @question' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template("answers/create")
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer, :invalid), format: :js }.to_not change(Answer, :count)
      end

      it 'redirect to @question' do
        post :create, question_id: question, answer: attributes_for(:answer, :invalid), format: :js
        expect(response).to render_template("answers/create")
      end
    end
  end

   describe 'DELETE #destroy' do

    before { answer }
    before { sign_in(user) }
    
      it 'deletes answer' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to @question' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to redirect_to question_path(question)
    end
  end
end
