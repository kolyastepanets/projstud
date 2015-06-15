require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

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

  describe 'PATCH #update' do

    before { sign_in(user) }
    
    it 'assigns requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes the answer' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'assigns answer to question and to user' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
      answer = assigns(:answer)
      expect(answer.user_id).to eq user.id
      expect(answer.question_id).to eq question.id
    end


    it 'render template update' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
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
        expect(response).to render_template("answers/destroy")
    end
  end

    describe 'PATCH #mark_solution' do
    let(:user1){ create(:user) }
    let(:user2){ create(:user) }
    let!(:question){ create(:question, user: user1) }
    let!(:answer1){ create(:answer, question: question, user: user2) }
    let!(:answer2){ create(:answer, question: question, user: user2) }

    it 'Author of question can select one of answers as solution answer' do
      sign_in(user1)
      patch :mark_solution, id: answer1.id, format: :js
      patch :mark_solution, id: answer2.id, format: :js
      answer1.reload
      answer2.reload

      expect(answer1.is_solution).to eq false
      expect(answer2.is_solution).to eq true
    end

    it 'Renders solution view' do
      sign_in(user1)
      patch :mark_solution, id: answer1.id, format: :js
      expect(response).to render_template ('mark_solution')
    end

    it 'Not owner of question can not select one of answers as solution answer' do
      sign_in(user2)
      patch :mark_solution, id: answer1.id, format: :js
      answer.reload
      expect(answer1.is_solution).to eq false
    end

    it 'Unauthenticated user can not select one of answers as solution answer' do
      patch :mark_solution, id: answer1.id, format: :js
      answer.reload
      expect(answer1.is_solution).to eq false
    end
  end
end
