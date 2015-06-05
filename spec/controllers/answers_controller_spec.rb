require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'with valid atrributes' do
      it 'saves new answer with question_id' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end

      it 'assigns answer to question_id' do
        post :create, question_id: question, answer: attributes_for(:answer)
        answer = assigns(:answer)
        expect(answer.question_id).to eq question.id
      end

      it 'redirects to show @question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer, :invalid) }.to_not change(Answer, :count)
      end

      it 'redirect to @question' do
        post :create, question_id: question, answer: attributes_for(:answer, :invalid)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
