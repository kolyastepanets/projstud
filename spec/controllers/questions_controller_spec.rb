require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

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

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, id: question}

    it 'assigns question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders #edit' do
      expect(response).to render_template :edit  
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid atrributes' do
      it 'saves new question' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'assigns question to user_id' do
        post :create, user_id: user, question: attributes_for(:question)
        expect(question.user_id).to eq user.id
      end

      it 'redirects to show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, question: attributes_for(:question, :invalid) }.to_not change(Question, :count)       
      end

      it 'renders #new' do
        post :create, question: attributes_for(:question, :invalid)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    
    context 'valid attributes' do
      it 'assigns question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes the question' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil } }

      it 'does not change attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq 'MyText'  
      end

      it 'renders #edit' do
        expect(response).to render_template :edit
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
end
