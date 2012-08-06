module Wicked
  module Action
    extend ActiveSupport::Concern

    # Include the modules!!
    include Wicked::Controller::Concerns::Path
    include Wicked::Controller::Concerns::RenderRedirect
    include Wicked::Controller::Concerns::Steps

    included do
      # Give our Views helper methods!
      helper_method :wizard_path,     :next_wizard_path, :previous_wizard_path,
                    :step,            :wizard_steps,     :current_step?,
                    :past_step?,      :future_step?,     :previous_step?,
                    :next_step?
    end

    # any subclass (Action class) should call super!
    def run
      setup_wizard      
    end

    module ClassMethods
      def wizard &block
        define_method :run do
          wizard_redirect and return if super()
          instance_eval &block
        end
      end
    end

    protected

    def setup_wizard
      @redirect_path = wizard_path(steps.first) if first_step? && !on_first_step?
      @redirect_path = wizard_path(steps.last)  if last_step? && !on_last_step?

      @step          = params[:id].try(:to_sym) || steps.first
      @previous_step = previous_step(@step)
      @next_step     = next_step(@step)   
      @redirect_path
    end

    def wizard_redirect
      redirect_to @redirect_path if @redirect_path
    end

    def on_first_step?
      step == steps.first
    end

    def on_last_step?
      step == steps.first
    end

    def first_step?
      params[:id].try(:to_sym) == :wizard_first
    end

    def last_step?
      params[:id].try(:to_sym) == :wizard_last
    end
  end
end