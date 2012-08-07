## This controller uses includes

module StepPositionsController
  class Action < FocusedAction
    include Wicked::Action

    steps :first, :second, :last_step
  end
  include Wicked::Wizard  

  wizard_action :show do
    wizard do
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
