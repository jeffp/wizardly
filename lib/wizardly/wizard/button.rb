require 'wizardly/wizard/text_helpers'

module Wizardly  
  module Wizard
    class Button
      include TextHelpers
      attr_reader :name
      attr_reader :id

      def initialize(id, name=nil)
        @id = id
        @name = name || sym_to_string(id)
      end

      def to(name)
        if name.is_a?(String)
          @name = name.strip.squeeze(' ')
          @id = string_to_sym(name)
        elsif name.is_a?(Symbol)
          @id = name
          @name = sym_to_string(name)
        end
      end
    end  
  end
end