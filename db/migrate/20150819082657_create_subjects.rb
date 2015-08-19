class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.integer :number_of_question
      t.integer :duration

      t.timestamps null: false
    end
  end
end