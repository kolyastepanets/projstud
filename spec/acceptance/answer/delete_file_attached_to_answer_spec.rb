require 'rails_helper'

feature 'Delete answer\'s file', %q{
  in order to correct my answer
  as an author answer
  i want to able to delete answer\'s file
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User deletes file', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your Answer', with: 'Test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add answer'

    click_on 'Delete File'
    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end