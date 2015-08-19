class Question < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user

  has_many :answers
  has_many :exams, through: :results
  has_many :results
end