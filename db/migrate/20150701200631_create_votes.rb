class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :score, default: 0
      t.references :votable, polymorphic:true, index: true
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
