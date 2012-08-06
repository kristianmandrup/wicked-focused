module Wicked
  module Wizard
    extend ActiveSupport::Concern

    included do
      focused_action :index, "{self.name}::Action".constantize do
        redirect_to wizard_path(steps.first)
      end 

      wizard_actions     
    end

    module ClassMethods
      def wizard_actions
        "{self.name}::Action".constantize.wizard_steps.each do |step|
          wizard_action step
        end
      end

      def wizard_action action, &block
        focused_action action, "{self.name}::Action".constantize, &block
      end
    end
  end
end