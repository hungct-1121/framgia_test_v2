class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :score
      t.string :status
      t.integer :time
      t.references :user, index: true, foreign_key: true
      t.references :subject, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end