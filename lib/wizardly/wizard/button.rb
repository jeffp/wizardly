require 'wizardly/wizard/text_helpers'

module Wizardly  
  module Wizard
    class Button
      include TextHelpers
      attr_reader :name
      attr_reader :id

      def initialize(id, name=nil)
        @id = id
        @name = name || symbol_to_button_name(id)
        @user_defined = false
      end
      
      def user_defined?; @user_defined; end

      #used in the dsl
      def name_to(name, opts={})
        case name
        when String then @name = name.strip.squeeze(' ')
        when Symbol then @name = symbol_to_button_name(name)
        end
        @id = opts[:id] if (opts[:id] && opts[:id].is_a?(Symbol))
      end
    end

    class UserDefinedButton < Button
      def initialize(id, name=nil)
        super
        @user_defined = true
      end
    end
  end
end