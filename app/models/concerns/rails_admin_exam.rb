module RailsAdminExam
  extend ActiveSupport::Concern

  included do
    rails_admin do
      show do

        field :status do
          pretty_value do
            status = bindings[:object]
            class_label = if status.start?
              "label label-primary"
            elsif status.testing?
              "label label-warning"
            elsif status.unchecked?
              "label label-info"
            else
              "label label-success"
            end
            %{<div class="#{class_label}">#{status.status}</div >}.html_safe
          end
        end
        field :time do
          label "Spent time"
          formatted_value{bindings[:object].spent_time_format}
        end
        field :id
        field :user
        field :subject
        field :questions
      end

      list do
        # filters [:user_id, :subject_id]
        # sort_by :created_at

        # field :user_id, :enum do
        #   enum do
        #     User.all.collect {|p| [p.name, p.id]}
        #   end
        #   hide
        # end
        field :subject_id, :enum do
          enum do
            Subject.all.collect {|p| [p.name, p.id]}
          end
          hide
        end
        field :id do
          column_width 20
          formatted_value do
            bindings[:view]
              .content_tag(:a,
                "#{bindings[:object].id}",
                href: "exam/#{bindings[:object].id}/mark_exam")
          end
        end
        field :created_at do
          column_width 150
          formatted_value do
            bindings[:view]
              .content_tag(:a,
                "#{bindings[:object].created_at.strftime("%Y-%m-%d %I:%M%p")}",
                href: "exam/#{bindings[:object].id}/mark_exam")
          end
        end
        field :user do
          column_width 100
        end
        field :subject do
          column_width 150
          label "Subject"
        end
        field :time do
          column_width 70
          label "Spent time"
          formatted_value{bindings[:object].spent_time_format}
        end
        field :score_exam do
          column_width 50
          label "Score"
        end
        field :status do
          column_width 70
          pretty_value do
            status = bindings[:object]
            class_label = if status.start?
              "label label-primary"
            elsif status.testing?
              "label label-warning"
            elsif status.unchecked?
              "label label-info"
            else
              "label label-success"
            end

            %{<div class="#{class_label}">#{status.status}</div >}.html_safe
          end
        end
        field :mark_exam do
          label ""
          column_width 50
          formatted_value do
            if bindings[:object].checked? || bindings[:object].unchecked?
              bindings[:view].content_tag(:a, "<p class='label label-primary'><b>Mark</b></p>".html_safe,
                href: "exam/#{bindings[:object].id}/mark_exam")
            end
          end
        end
      end
    end
  end
end
