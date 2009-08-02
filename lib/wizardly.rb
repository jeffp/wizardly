require 'wizardly/validation_group'
require 'wizardly/action_controller'

module Wizardly
  module ActionController
    module MacroMethods
      def wizard_for_model(model, opts={}, &block)
        include Wizardly::ActionController
        #check for validation group gem
        configure_wizard_for_model(model, opts, &block)
      end
      alias_method :act_wizardly_for, :wizard_for_model
    end
  end
end

begin
  ActiveRecord::Base.class_eval do
    class << self
      alias_method :wizardly_page, :validation_group
    end
  end
rescue
end

ActionController::Base.send(:extend, Wizardly::ActionController::MacroMethods)





