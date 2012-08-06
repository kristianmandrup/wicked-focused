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

      expose(:step)           { current_step || steps.first }    
      expose(:previous_step)  { previous_step(step) }
      expose(:next_step)      { next_step(step) }
    end

    # any subclass (Action class) should call super!
    def run
      setup_wizard
    end

    protected

    def setup_wizard
      redirect_to wizard_path(steps.first) if first_step?
      redirect_to wizard_path(steps.last)  if last_step?
    end

    def current_step
      params[:id].try(:to_sym)
    end

    def first_step?
      params[:id].try(:to_sym) == :wizard_first
    end

    def last_step?
      params[:id].try(:to_sym) == :wizard_last
    end
  end
end