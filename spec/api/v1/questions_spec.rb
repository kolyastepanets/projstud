require 'rails_helper'

describe 'Questions API' do
  let!(:user) { create(:user) }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response).to have_http_status 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions[1] }
      let!(:answer) { create(:answer, question: question, user: user) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response).to have_http_status 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:comment) { comments.first }
      let!(:attachments) { create_list(:attachment, 3, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("one_question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("one_question/comments")
        end

        %w(id content created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("one_question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(3).at_path("one_question/attachments")
        end

        it "contains url" do
          expect(response.body).to be_json_eql(question.attachments[0].file.url.to_json).at_path("one_question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions", format: :json, question: attributes_for(:question)
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions", format: :json, question: attributes_for(:question), access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          post "/api/v1/questions", format: :json, question: attributes_for(:question), access_token: access_token.token
          expect(response).to have_http_status :created
        end

        it 'saves the new question in the database' do
          expect { post "/api/v1/questions", format: :json, question: attributes_for(:question), access_token: access_token.token }.to change(Question, :count).by(1)
        end

        it 'assigns created question to the user' do
          expect { post "/api/v1/questions", format: :json, access_token: access_token.token, question: attributes_for(:question)}.to change(me.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 401 status code' do
          post "/api/v1/questions", format: :json, question: attributes_for(:question, :invalid), access_token: access_token.token
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'do not save the new question in the database' do
          expect { post "/api/v1/questions", format: :json, question: attributes_for(:question, :invalid), access_token: access_token.token }.to_not change(Question, :count)
        end

        it 'do not assign created question to the user' do
          expect { post "/api/v1/questions", format: :json, access_token: access_token.token, question: attributes_for(:question, :invalid) }.to_not change(me.questions, :count)
        end
      end
    end
  end
end