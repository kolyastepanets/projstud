require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:votable) { create(described_class.controller_name.singularize.underscore) }
  let(:vote) { create(:vote, votable: votable, user: user2) }

  it_behaves_like "Voting"

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'has array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question, user: user }

    it 'assigns question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }
    it 'creates new question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders #new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid atrributes' do
      it 'saves new question' do
        expect { post :create, question: attributes_for(:question), format: :js }.to change(Question, :count).by(1)
      end

      it 'assigns question to user_id' do
        post :create, user_id: user, question: attributes_for(:question), format: :js
        expect(question.user_id).to eq user.id
      end

      it 'redirects to show' do
        post :create, question: attributes_for(:question), format: :js
        expect(response).to be_success
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, question: attributes_for(:question, :invalid), format: :js }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
        expect(question.user_id).to eq user.id
      end

      it 'changes the question' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil }, format: :js }

      it 'does not change attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq 'MyText'
      end

      it 'renders #edit' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { question }

    it 'deletes question' do
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end

    it 'redirect to #index' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end

  describe 'GET #click' do
    it 'increment the clicks' do
      expect{ get :click, id: question }.to change{Question.count}.from(0).to(1)
    end

    it 'renders @question' do
      get :click, id: question
      expect(response).to redirect_to question_path(assigns(:question))
    end
  end
end