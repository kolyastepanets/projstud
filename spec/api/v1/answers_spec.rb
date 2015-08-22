require 'rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do

    let(:answer) { create(:answer, question: question, user: user) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at body).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("one_answer/#{attr}")
        end
      end

      context 'comments' do
        %w(id content created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("one_answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it "contains url" do
          expect(response.body).to be_json_eql(answer.attachments[0].file.url.to_json).at_path("one_answer/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:answer)
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:answer), access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:answer), access_token: access_token.token
          expect(response).to have_http_status :created
        end

        it 'saves the new answer in the database' do
          expect { post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:answer), access_token: access_token.token }.to change(Answer, :count).by(1)
        end

        it 'assigns created answer to the question' do
          expect { post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer)}.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 401 status code' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:answer, :invalid), access_token: access_token.token
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'do not save the new answer in the database' do
          expect { post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:answer, :invalid), access_token: access_token.token }.to_not change(Answer, :count)
        end

        it 'do not assign created answer to the question' do
          expect { post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer, :invalid)}.to_not change(question.answers, :count)
        end
      end
    end
  end
end