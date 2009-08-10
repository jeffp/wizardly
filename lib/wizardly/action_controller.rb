require 'wizardly/wizard'

module Wizardly
  module ActionController
    def self.included(base)
      base.extend(ClassMethods)
      
      base.class_eval do
        before_filter :guard_entry
        class << self
          attr_reader :wizard_config #note: reader for @wizard_config on the class (not the instance)
        end
        hide_action :reset_wizard_session_vars, :wizard_config, :methodize_button_name
      end
    end

    module ClassMethods
      private
      def configure_wizard_for_model(model, opts={}, &block)
        
        # controller_name = self.name.sub(/Controller$/, '').underscore.to_sym
        @wizard_config = Wizardly::Wizard::Configuration.create(controller_name, model, opts, &block)
        # define methods
        self.class_eval @wizard_config.print_page_action_methods
        self.class_eval @wizard_config.print_callbacks
        self.class_eval @wizard_config.print_helpers
      end
    end

    # instance methods for controller
    public
    def wizard_config; self.class.wizard_config; end

    private
    def reset_wizard_session_vars
      session[:progression] = nil
      init = session[:initial_referer]
      session[:initial_referer] = nil
      init
    end

    # better name: underscore_button_name, changes submit_tag button names like
    # 'Next Step' ==> 'next_step', used to identify callback methods
    def methodize_button_name(value)
      value.to_s.strip.squeeze(' ').gsub(/ /, '_').downcase
    end
  end
end