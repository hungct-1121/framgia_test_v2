module RailsAdmin
  module Config
    module Actions
      class ShowQuestion < RailsAdmin::Config::Actions::Base

        register_instance_option :visible? do
          authorized? && bindings[:object].class == Question
        end

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          "icon-info-sign"
        end

        register_instance_option :pjax? do
          false
        end

        register_instance_option :http_methods do
          [:get, :post, :patch]
        end

        register_instance_option :route_fragment do
          custom_key.to_s
        end

        register_instance_option :action_name do
          custom_key.to_sym
        end

        register_instance_option :custom_key do
          key
        end

        register_instance_option :controller do
          proc do
            @option_answers = object.options
            respond_to do |format|
              format.json { render json: @object }
              format.html { render @action.template_name }
            end
          end
        end

        def key
          self.class.key
        end
      end
    end
  end
end