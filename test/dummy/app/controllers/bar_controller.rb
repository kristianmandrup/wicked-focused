## This controller uses includes

module BarController
  use_wicked_macros
  
  wicked_base_action do
    steps :first, :second, :last_step
  end    
  
  wizard_action :show do
    wizard do
      skip_step if params[:skip_step]
      render_wizard
    end
  end

  focused_action :update
end
