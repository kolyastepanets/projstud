class AddClicksToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :clicks, :integer, default: 0
  end
end
