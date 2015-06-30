require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe 'page home' do 
    let(:questions) { create_list(:question, 2) }

    before { get :home }

    it 'has array of questions' do  
      expect(assigns(:questions)).to match_array(questions) 
    end

    it 'render index' do
      expect(response).to render_template :home
    end
  end

  describe "GET #help" do
    it "returns http success" do
      get :help
      expect(response).to have_http_status(:success)
    end
  end

end
