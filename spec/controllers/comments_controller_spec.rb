require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }
  
  describe 'POST #create' do
    before { sign_in(user) } 

    context 'with valid atrributes for question' do
      it 'saves new comment with question_id' do
        expect { post :create, 
                 question_id: question, 
                 commentable: 'questions', 
                 comment: attributes_for(:comment), 
                 format: :js 
                 }.to change(Comment, :count).by(1)
      end

      it 'assigns comment to question_id' do
        post :create, question_id: question, commentable: 'questions', 
             comment: attributes_for(:comment), format: :js
        
        comment = assigns(:comment)
        expect(comment.user_id).to eq user.id
        expect(comment.commentable_id).to eq question.id
      end

      it 'redirects to show @question' do
        post :create, question_id: question, commentable: 'questions', 
             comment: attributes_for(:comment), format: :js
        
        expect(response).to render_template("comments/create")
      end
    end

    context 'with invalid attributes for question' do
      it 'does not save comment' do
        expect { post :create, 
                 question_id: question, 
                 commentable: 'questions', 
                 comment: attributes_for(:comment, :invalid), 
                 format: :js 
                 }.to_not change(Comment, :count)
      end

      it 'redirect to @question' do
        post :create, question_id: question, commentable: 'questions', 
             comment: attributes_for(:comment, :invalid), format: :js
        
        expect(response).to render_template("comments/create")
      end
    end

    context 'with valid atrributes for answer' do
      it 'saves new comment with answer_id' do
        expect { post :create, 
                 answer_id: answer, 
                 commentable: 'answers', 
                 comment: attributes_for(:comment), 
                 format: :js 
                 }.to change(Comment, :count).by(1)
      end

      it 'assigns comment to answer_id' do
        post :create, answer_id: answer, commentable: 'answers', 
             comment: attributes_for(:comment), format: :js
        
        comment = assigns(:comment)
        expect(comment.user_id).to eq user.id
        expect(comment.commentable_id).to eq answer.id
      end

      it 'redirects to show @question' do
        post :create, answer_id: answer, commentable: 'answers', 
             comment: attributes_for(:comment), format: :js
        
        expect(response).to render_template("comments/create")
      end
    end

    context 'with invalid attributes for answer' do
      it 'does not save comment' do
        expect { post :create, 
                 answer_id: answer, 
                 commentable: 'answers', 
                 comment: attributes_for(:comment, :invalid), 
                 format: :js 
                 }.to_not change(Comment, :count)
      end

      it 'redirect to @question' do
        post :create, answer_id: answer, commentable: 'answers', 
             comment: attributes_for(:comment, :invalid), format: :js
        
        expect(response).to render_template("comments/create")
      end
    end
  end
end
