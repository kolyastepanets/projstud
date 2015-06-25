require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:question) { create(:question, user: user) }
  let(:attachment_question) { create(:attachment, attachable: question) }
  let(:attachment_answer) { create(:attachment, attachable: answer) }

  describe 'DELETE #destroy' do

    context 'delete question' do
      before { sign_in(attachment_question.attachable.user) }
      it 'deletes question\'s attachment' do
        expect { delete :destroy, id: attachment_question, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'redirects to @question' do
        delete :destroy, id: attachment_question, format: :js
        expect(response).to render_template("attachments/destroy")
      end
    end

    context 'delete answer' do
      before { sign_in(attachment_answer.attachable.user) }
      it 'deletes answer\'s attachment' do
        expect { delete :destroy, id: attachment_answer, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'redirects to @question' do
        delete :destroy, id: attachment_answer, format: :js
        expect(response).to render_template("attachments/destroy")
      end
    end
  end
end
