## This controller uses inheritance

module FooController
  class Action < FocusedAction
    include Wicked::Action

    steps :first, :second, :last_step

    # alias: allow_skip_for
    optional_steps :first
  end
  include Wicked::Wizard  

  wizard_action :show do
    wizard do
      # skip_step if skip_step?
      render_wizard
    end
  end

  wizard_action :update do
    wizard do
      # update code here!
      render_wizard
    end
  end    
end
