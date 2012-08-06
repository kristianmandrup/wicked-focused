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

      wizard_actions     
    end

    module ClassMethods
      def wizard_actions
        clazz = "#{self.name}::Action".constantize
        steps = clazz.wizard_steps
        raise "No wizard steps defined for #{clazz}" if steps.blank?
        steps.each do |step|
          wizard_action step
        end
      end

      def wizard_action action, &block
        focused_action action, "#{self.name}::Action".constantize, &block
      end
    end
  end
end