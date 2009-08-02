module Wizardly
  module Wizard
    module TextHelpers
      private
      def string_to_sym(str)
        str.downcase.strip.squeeze(' ').gsub(/ /, '_').to_sym
      end
      def sym_to_string(sym)
        sym.to_s.gsub(/_/, ' ').squeeze(' ').titleize
      end
    end
  end
end