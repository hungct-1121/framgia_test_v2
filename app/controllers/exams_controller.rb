class ExamsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :correct_user?, only: [:show, :update]

  def index
    @exam = Exam.new
    @subjects = Subject.order :name
    @exams = current_user.exams.order(created_at: :desc).page params[:page]
  end

  def show
    @subject = @exam.subject
    if @exam.start?
      questions = Question.random_with_subject(@exam.subject)
      if questions.size < @exam.number_of_question
        redirect_to root_path, alert: flash_message("not_start")
      else
        @exam.update_attributes status: :testing, questions: questions
      end
    end
  end

  def create
    @exam = current_user.exams.build exam_params
    if @exam.save
      redirect_to root_path, notice: flash_message("created")
    else
      flash.now[:alert] = t "flashs.messages.exam_create_reject",
        subject: @exam.subject.name
    end
  end

  def update
    @exam.update_attributes time: @exam.spent_time
    if @exam.time_out? || params[:commit] == Settings.exam.state.finish
      @exam.update_attributes status: :unchecked
    end

    if @exam.update_attributes exam_params
      @exam.set_mark
      flash[:notice] = t "flashs.messages.submit_success"
    else
      flash[:alert] = t "flashs.messages.invalid"
    end
    redirect_to root_path
  end


  private
  def exam_params
    params.require(:exam).permit Exam::PARAMS_ATTRIBUTES
  end

  def correct_user?
    redirect_to root_path unless current_user == @exam.user
  end
end
