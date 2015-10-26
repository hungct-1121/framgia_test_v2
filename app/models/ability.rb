class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    if user.admin?
      can :access, :rails_admin
      can :dashboard
      can :destroy, :all
      can :export, :all
      can :index, :all
      can :new, :all
      can :edit, :all
      can :show_in_app, :all
      can :show, :all
      can :create_question, Question
      can :import, Question
      can :mark_exam, Exam do |exam|
        exam.unchecked? || exam.checked?
      end
      can :active_question, Question do |question|
        !question.active?
      end
      can :edit_question, Question
      can :deactive_question, Question do |question|
        question.active?
      end
      can :multi_active_question, Question
      can :multi_deactive_question, Question
      can :show_question, Question
      can :manage, [User, Subject]
    else
      can :read, :all
      can :create, [Question, Exam]
      can :update, [Question, Exam, Result]
    end
  end
end
