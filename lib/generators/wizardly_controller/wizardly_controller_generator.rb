require 'wizardly'

class WizardlyControllerGenerator < Rails::Generator::Base
  attr_reader :controller_name, :model_name, :completed_redirect, :canceled_redirect
  
  def initialize(runtime_args, runtime_options = {})
    super
    @controller_name = @args[0].sub(/^:/, '').underscore
    @model_name = @args[1].sub(/^:/, '').underscore
    @completed_redirect = @args[2]
    @canceled_redirect = @args[3]
    opts = {}
    opts[:completed] = @completed_redirect if @completed_redirect
    opts[:canceled] = @canceled_redirect if @canceled_redirect
    
    @wizard_config = Wizardly::Wizard::Configuration.new(@controller_name.to_sym, opts)
    @wizard_config.inspect_model!(@model_name.to_sym)
  end
  
  def manifest
    record do |m|
      m.directory "app/controllers"
      
      m.template "controller.rb.erb", "app/controllers/#{controller_name}_controller.rb"
      
      m.template "helper.rb.erb", "app/helpers/#{controller_name}_helper.rb"
      
    end
  end
  
  def controller_class_name
    "#{controller_name.camelize}Controller"
  end
  def model_class_name
    "#{model_name.camelize}"
  end
  def action_methods
    @wizard_config.print_page_action_methods
  end
  def callback_methods
    @wizard_config.print_callbacks
  end
  def helper_methods
    @wizard_config.print_helpers
  end
  def callback_macro_methods
    @wizard_config.print_callback_macros
  end
  
  protected
  # Override with your own usage banner.
  def banner
    "Usage: #{$0} wizardly_controller controller_name model_name [completed_redirect canceled_redirect]"
  end
  
  
end
