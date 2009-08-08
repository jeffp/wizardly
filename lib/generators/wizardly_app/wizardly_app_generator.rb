#require 'wizardly'

class WizardlyAppGenerator < Rails::Generator::Base
  
  def initialize(runtime_args, runtime_options = {})
    super
  end
  
  def manifest
    record do |m|
      m.directory "lib/tasks"
      
      m.file "wizardly.rake", "lib/tasks/wizardly.rake"
      
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
  
  protected
  # Override with your own usage banner.
  def banner
    "Usage: #{$0} wizardly_app"
  end
  
  
end
