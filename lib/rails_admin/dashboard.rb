module RailsAdmin
  module Config
    module Actions
      class Dashboard < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end

        register_instance_option :breadcrumb_parent do
          nil
        end

        register_instance_option :controller do
          proc do
            params[:mfq] ||= Settings.default_num_of_most_failed_question
            @num_of_most_failed_question = Question.most_failed_json params[:mfq]
            @score_frequency = Exam.score_frequency_json
            @history = @auditing_adapter && @auditing_adapter.latest || []
            if @action.statistics?
              @abstract_models = RailsAdmin::Config.visible_models(controller: self).collect(&:abstract_model)
              @most_recent_changes = {}
              @count = {}
              @max = 0
              @abstract_models.each do |t|
                scope = @authorization_adapter && @authorization_adapter.query(:index, t)
                current_count = t.count({}, scope)
                @max = current_count > @max ? current_count : @max
                @count[t.model.name] = current_count
                next unless t.properties.detect { |c| c.name == :updated_at }
                @most_recent_changes[t.model.name] = t.first(sort: "#{t.table_name}.updated_at").try(:updated_at)
              end
            end
            render @action.template_name, status: (flash[:error].present? ? :not_found : 200)
          end
        end

        register_instance_option :route_fragment do
          ''
        end

        register_instance_option :link_icon do
          'icon-home'
        end

        register_instance_option :statistics? do
          true
        end
      end
    end
  end
end
