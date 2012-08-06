module Wicked::Controller::Concerns::Path
  extend ActiveSupport::Concern

  def next_wizard_path(options = {})
    wizard_path(@next_step, options)
  end

  def previous_wizard_path(options = {})
    wizard_path(@previous_step, options)
  end

  def wicked_controller
    self.class.name.sub(/::\w+$/, '')
  end

  def wicked_controller_name
    wicked_controller.sub(/Controller$/, '').gsub('::', '_').underscore
  end

  def wicked_action
    params[:action]
  end

  def wizard_path(goto_step = nil, options = {})
    id = goto_step || params[:id]
    path_method = "#{wicked_controller_name}_path"
    send path_method, id, options
  end
end
