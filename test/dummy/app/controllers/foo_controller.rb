## This controller uses inheritance

module FooController
  class Action < FocusedAction
    include Wicked::Action

    steps :first, :second, :last_step
  end
  include Wicked::Wizard  

  wizard_action :show do
    def run
      skip_step if params[:skip_step]
      render_wizard
    end
  end

  wizard_action :update
end
