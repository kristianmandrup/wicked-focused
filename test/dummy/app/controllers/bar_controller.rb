## This controller uses includes

module BarController
  use_wicked_macros
  
  wicked_base_action do
    steps :first, :second, :last_step
  end    
  
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
