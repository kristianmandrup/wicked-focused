module Wicked
  module Controller
    module Concerns
    end
  end
  module Wizard
  end
end

class ApplicationController < ActionController::Base
end

require 'focused_controller'
require 'focused_controller/macros'
require 'focused_controller/focused_action'

require 'wicked/controller/concerns/render_redirect'
require 'wicked/controller/concerns/steps'
require 'wicked/controller/concerns/path'
require 'wicked/action'
require 'wicked/wizard'
require 'wicked/macros'
require 'wicked/engine'


