require Rails.root.join("lib", "rails_admin", "mark_exam.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::MarkExam)
require Rails.root.join("lib", "rails_admin", "edit_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::EditQuestion)
require Rails.root.join("lib", "rails_admin", "create_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::CreateQuestion)
require Rails.root.join("lib", "rails_admin", "show_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ShowQuestion)
require Rails.root.join("lib", "rails_admin", "active_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ActiveQuestion)
require Rails.root.join("lib", "rails_admin", "deactive_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::DeactiveQuestion)
require Rails.root.join("lib", "rails_admin", "multi_active_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::MultiActiveQuestion)
require Rails.root.join("lib", "rails_admin", "multi_deactive_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::MultiDeactiveQuestion)
require Rails.root.join("lib", "rails_admin", "dashboard.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::Dashboard)
require Rails.root.join("lib", "rails_admin", "import.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::Import)

RailsAdmin::ApplicationHelper.class_eval do
  def menu_for(parent, abstract_model = nil, object = nil, only_icon = false) # perf matters here (no action view trickery)
    actions = actions(parent, abstract_model, object).select { |a| a.http_methods.include?(:get) && a.action_name != :mark_exam }
    actions.collect do |action|
      wording = wording_for(:menu, action)
      %(
        <li title="#{wording if only_icon}" rel="#{'tooltip' if only_icon}" class="icon #{action.key}_#{parent}_link #{'active' if current_action?(action)}">
          <a class="#{action.pjax? ? 'pjax' : ''}" href="#{rails_admin.url_for(action: action.action_name, controller: 'rails_admin/main', model_name: abstract_model.try(:to_param), id: (object.try(:persisted?) && object.try(:id) || nil))}">
            <i class="#{action.link_icon}"></i>
            <span#{only_icon ? " style='display:none'" : ''}>#{wording}</span>
          </a>
        </li>
      )
    end.join.html_safe
  end

  def link_to_add_fields label, f, assoc
    new_obj = f.object.class.reflect_on_association(assoc).klass.new
    fields = f.fields_for assoc, new_obj,child_index: "new_#{assoc}" do |builder|
      render "#{assoc.to_s.singularize}_fields", f: builder
    end
    link_to label, "#", class: "add-button fa fa-plus",
      onclick: "add_fields(this, \"#{assoc}\", \"#{escape_javascript(fields)}\")", remote: true
  end

  def link_to_remove_fields label, f
    field = f.hidden_field :_destroy
    link = link_to label, "#",
      class: "remove-button fa fa-trash text-danger",
      onclick: "remove_fields(this)", remote: true
    field + link
  end

  def flash_message flash_type
    t "flashs.messages.#{flash_type}", model_name: controller_name.classify
  end
end

RailsAdmin.config do |config|
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)
  config.authorize_with :cancan
  config.main_app_name = ["Sun-asterisk Test System", "Admin"]

  config.actions do
    import do
      only Question
    end
    dashboard
    index
    create_question do
      only Question
    end
    new do
      except ["Exam", "Question"]
    end
    export
    bulk_delete
    multi_active_question do
      only Question
    end
    multi_deactive_question do
      only Question
    end
    mark_exam
    show_question
    show do
      except ["Question", "Exam"]
    end
    edit_question
    edit do
      except ["Exam", "Question"]
    end
    active_question do
      only Question
    end
    deactive_question do
      only Question
    end
    delete
    show_in_app do
      except ["User", "Exam"]
    end
  end
  config.excluded_models = ["Answer", "Option", "Result"]
end
