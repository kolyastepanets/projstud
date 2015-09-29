require 'rails_helper'

feature 'Search content', '
  In order to find content
  As a visitor of the site
  I should be able to search information
' do
  given(:user) { create :user, email: 'testuser@example.com' }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }
  given!(:comment) { create :comment, user: user, commentable: question, commentable_type: 'Question' }

  scenario 'User searches everywhere', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.form-inline' do
        fill_in 'query', with: 'testuser'
        select 'Everywhere', from: 'type'
        click_on 'Go'
      end

      within '.result' do
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
        expect(page).to have_content comment.content
        expect(page).to have_content user.email
      end
    end
  end

  scenario 'User searches question', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.form-inline' do
        fill_in 'query', with: 'testuser'
        select 'Question', from: 'type'
        click_on 'Go'
      end

      within '.result' do
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to_not have_content comment.content
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'User searches answer', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.form-inline' do
        fill_in 'query', with: 'testuser'
        select 'Answer', from: 'type'
        click_on 'Go'
      end

      within '.result' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content answer.body
        expect(page).to_not have_content comment.content
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'User searches comment', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.form-inline' do
        fill_in 'query', with: 'testuser'
        select 'Comment', from: 'type'
        click_on 'Go'
      end

      within '.result' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to have_content comment.content
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'User searches user', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.form-inline' do
        fill_in 'query', with: 'testuser'
        select 'User', from: 'type'
        click_on 'Go'
      end

      within '.result' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to_not have_content comment.content
        expect(page).to have_content user.email
      end
    end
  end
end