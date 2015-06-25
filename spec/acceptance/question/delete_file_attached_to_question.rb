require 'rails_helper'

feature 'Delete question\'s file', %q{
  in order to correct my question
  as an author question
  i want to able to delete question\'s file
} do 

  given(:user) { create(:user) }

  scenario 'User deletes file', js: true do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    click_on 'Delete File'
    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end