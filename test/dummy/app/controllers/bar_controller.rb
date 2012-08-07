## This controller uses includes

module BarController
  use_wicked_macros
  
  wicked_base_action do
    steps :first, :second, :last_step
    
    command_steps :first
  end    
  
  wizard_action :show do
    wizard do
      # skip_step if skip_step?
      command_for step # should be in update!

      render_wizard
    end

    def command! name
      puts "execute command: #{name}"
    end
  end

  wizard_action :update do
    wizard do
      command_for step
      # update code here!
      render_wizard
    end
  end    
end
