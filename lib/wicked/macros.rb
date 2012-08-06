class Module
  def use_wicked_macros
    use_focused_macros
    extend Wicked::Macros
  end
end

module Wicked
  module Macros
    def wicked_wizard
      include Wicked::Wizard
    end

    def wicked_base_action &block
      focused_action :action do
        include Wicked::Action
        
        instance_eval &block
      end
      wicked_wizard
    end    
  end
end
