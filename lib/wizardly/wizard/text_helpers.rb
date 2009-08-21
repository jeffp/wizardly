module Wizardly
  module Wizard
    module TextHelpers
      private
      def underscore_button_name(name)
        name.to_s.strip.squeeze(' ').gsub(/ /, '_').downcase
      end
      def button_name_to_symbol(str)
        underscore_button_name(str).to_sym
      end
      def symbol_to_button_name(sym)
        sym.to_s.gsub(/_/, ' ').squeeze(' ').titleize
      end
    end
  end
end