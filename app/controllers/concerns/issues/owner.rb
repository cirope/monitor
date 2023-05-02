module Issues::Owner
  extend ActiveSupport::Concern

  included do
    before_action :set_owner
  end

    private

      def set_owner
        @owner = if params[:script_id].present?
                   Script.find params[:script_id]
                 elsif params[:rule_id].present?
                   Rule.find params[:rule_id]
                 end
      end
end
