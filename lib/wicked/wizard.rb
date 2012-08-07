module Wicked
  module Wizard
    extend ActiveSupport::Concern

    included do
      use_focused_macros
      focused_action :index, "#{self.name}::Action".constantize do
        run do
          redirect_to wizard_path(steps.first)
        end
      end 
    end

    module ClassMethods
      def wizard_actions *names
        names.each do |name|
          wizard_action name
        end
      end

      def wizard_action action, &block
        focused_action action, "#{self.name}::Action".constantize, &block
      end

      def show_wizard &block
        focused_action :show, "#{self.name}::Action".constantize, &block
      end

      def update_wizard &block
        focused_action :update, "#{self.name}::Action".constantize, &block
      end
    end
  end
end