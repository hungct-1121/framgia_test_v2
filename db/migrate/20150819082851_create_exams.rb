class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :score
      t.integer :status, default: 0
      t.integer :time, default: 0
      t.references :user, index: true, foreign_key: true
      t.references :subject, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
