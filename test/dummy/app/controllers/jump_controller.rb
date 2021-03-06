## This controller uses includes

module JumpController
  class Action < FocusedAction
    include Wicked::Action

    steps :first, :second, :last_step
  end
  include Wicked::Wizard  

  wizard_action :show do
    wizard do
      # skip_step if skip_step?
      jump_to :last_step if params[:jump_to]
      if params[:resource]
        value = params[:resource][:save] == 'true'
        @bar  = Bar.new(value)
        render_wizard(@bar)
      else
        render_wizard
      end
    end
  end

  wizard_action :update do
    wizard do
      # update code here!
      render_wizard
    end
  end    
end
