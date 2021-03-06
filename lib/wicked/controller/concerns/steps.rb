module Wicked::Controller::Concerns::Steps
  extend ActiveSupport::Concern

  def jump_to(goto_step)
    @skip_to = goto_step
  end

  def skip_step
    @skip_to = @next_step
  end

  def step
    @step
  end

  # will return true if step passed in is the currently rendered step
  def current_step?(step_name)
    return false if step_name.nil? || step.nil?
    step == step_name
  end

  # will return true if the step passed in has already been executed by the wizard
  def past_step?(step_name)
    return false if steps.index(step).nil? || steps.index(step_name).nil?
    steps.index(step) > steps.index(step_name)
  end

  # will return true if the step passed in has already been executed by the wizard
  def future_step?(step_name)
    return false if steps.index(step).nil? || steps.index(step_name).nil?
    steps.index(step) < steps.index(step_name)
  end

  # will return true if the last step is the step passed in
  def previous_step?(step_name)
    return false if steps.index(step).nil? || steps.index(step_name).nil?
    steps.index(step) - 1  == steps.index(step_name)
  end

  # will return true if the next step is the step passed in
  def next_step?(step_name)
    return false if steps.index(step).nil? || steps.index(step_name).nil?
    steps.index(step) + 1  == steps.index(step_name)
  end

  module ClassMethods
    attr_reader :wizard_steps, :skip_steps, :command_steps

    def steps(*args)
      options = args.last.is_a?(Hash) ? callbacks.pop : {}
      steps   = args
      @wizard_steps = args
      prepend_before_filter(options) do
        self.steps = steps
      end
    end

    def allow_skip_for(*args)
      @skip_steps = args
    end
    alias :optional_steps :allow_skip_for

    def command_steps(*args)
      return @command_steps if args.empty?
      @command_steps = args
    end
  end

  def steps=(wizard_steps)
    @wizard_steps = wizard_steps
  end

  def steps
    @wizard_steps
  end
  alias :wizard_steps :steps
  alias :steps_list   :steps

  def skip_step?
    return false unless params[:skip_step]
    return true if skip_steps.blank?
    skip_steps.include? step.to_sym
  end

  def skip_steps
    @skip_steps ||= self.class.superclass.skip_steps
  end

  def previous_step(current_step = nil)
    return previous_step if current_step == nil
    index =  steps.index(current_step)
    step  =  steps.at(index - 1) if index.present? && index != 0
    step ||= steps.first
    step
  end


  def next_step(current_step = nil)
    return next_step if current_step == nil
    index = steps.index(current_step)
    step  = steps.at(index + 1) if index.present?
    step  ||= :finish
    step
  end


end
