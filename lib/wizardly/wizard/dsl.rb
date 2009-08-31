module Wizardly
  module Wizard
    class DSL
    
      def initialize(config)
        @config = config
      end
    
      # DSL methods
      def when_completed_redirect_to(redir); @config._when_completed_redirect_to(redir); end
      def when_canceled_redirect_to(redir); @config._when_canceled_redirect_to(redir); end
      def change_button(name)
        @config._change_button(name)
      end
      def create_button(name, opts)
        @config._create_button(name, opts)
      end
      def set_page(name); 
        @config._set_page(name)
      end
      def mask_passwords(passwords)
        @config._mask_passwords(passwords)
      end
      alias_method :mask_password, :mask_passwords    
    end    
  end
end