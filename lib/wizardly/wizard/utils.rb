module Wizardly
  module Wizard
    module Utils
      def self.formatted_redirect(r)
        return(nil) unless r
        r.is_a?(Hash)? r : "'#{r}'"
      end
    end
  end
end

