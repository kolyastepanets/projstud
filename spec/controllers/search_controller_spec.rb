require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #index" do
    it 'should find' do
      expect(ThinkingSphinx).to receive(:search).with("my search")
      get :index, query: "my search"
    end
  end
end