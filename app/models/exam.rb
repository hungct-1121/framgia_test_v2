class Exam < ActiveRecord::Base
  include RailsAdminExam

  belongs_to :user
  belongs_to :subject
  has_many :questions, through: :results
  has_many :results, dependent: :destroy

  enum status: [:start, :testing, :checked, :unchecked]

  accepts_nested_attributes_for :results

  scope :select_exam_not_finish, ->user_id{where user_id: user_id, status: [0, 1]}
  scope :with_score, ->(score){where score: score}
  scope :descending_by_score, ->{order(score: :desc)}

  class << self
    def score_frequency_json
      max_score = Exam.descending_by_score.first.score ||= 0
      min_score = Exam.descending_by_score.last.score ||= 0
      (min_score..max_score).map{|score| [score, Exam.with_score(score).count]}.to_json
    end
  end

  def create_results
    self.questions = subject.random_questions
  end

  def time_out?
    if results.count > 0
      created_time = results.first.created_at
      (Time.zone.now > created_time + subject.duration.minutes) || unchecked? || checked?
    end
  end

  def spent_time
    interval = Time.zone.now - results.first.created_at
    time = interval > subject.duration * 60 ? subject.duration * 60 : interval
  end

  def update_status_exam
    update_attribute :status, :unchecked  if time_out? && testing?
  end

  def send_score_to_chatwork user
    ChatWork.api_key = user.chatwork_api_key
    room_id = subject.chatwork_room_id
    body = I18n.t("exam.labels.score_inform", subject: subject.name, score: score, total: subject.number_of_question,
      to_id: user.chatwork_id, user_name: user.name)
    ChatWork::Message.create room_id: room_id, body: body
  end

  def calculate_score
    results.where(correct: true).count
  end

  def set_mark
    self.results.each{|result| result.check_result}
    self.update score: self.calculate_score
  end

  def duration
    unchecked? ||checked? ? 0 : subject.duration * 60 - (Time.zone.now -
      results.first.created_at).to_i
  end

  def score_exam
    "#{score}/#{subject.number_of_question}" unless score.nil?
  end

  def spent_time_format
    Time.at(time).utc.strftime("%H:%M:%S")
  end
end
