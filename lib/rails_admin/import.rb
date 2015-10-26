module RailsAdmin
  module Config
    module Actions
      class Import < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :template_name do
          :import
        end
        register_instance_option :collection? do
          true
        end

        register_instance_option :route_fragment do
          custom_key.to_s
        end

        register_instance_option :link_icon do
          "icon-download-alt"
        end

        register_instance_option :action_name do
          custom_key.to_sym
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :controller do
          Proc.new do
            if request.post?
              file = params[:file]
              begin
                Question.import_csv file, current_user
                flash[:alert] = t "messages.csv.import_success"
                redirect_to rails_admin.index_path("Question")
              rescue Exception => e
                flash[:alert] = t("messages.csv.import_failed") + "." + e.class.to_s
                redirect_to rails_admin.import_path("Question")
              end
            end
          end
        end
      end
    end
  end
end
