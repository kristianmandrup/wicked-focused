## This controller uses includes

module BarController
  class Action < FocusedAction
    include Wicked::Action

    steps :first, :second, :last_step
  end
  include Wicked::Wizard  

  wizard_action :show do
    run do
      skip_step if params[:skip_step]
      render_wizard
    end
  end

  focused_action :update
end
