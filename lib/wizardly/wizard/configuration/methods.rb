module Wizardly
  module Wizard
    class Configuration
      
      def print_page_action_methods
        mb = StringIO.new
        self.pages.each do |id, p|
          mb << <<-COMMENT

  # #{id} action method
#{self.print_page_action_method(id)}
          COMMENT
        end
        mb << <<-INDEX
  def index
    redirect_to :action=>:#{self.page_order.first}
  end
        INDEX
        mb.string
      end
    
      def print_page_action_method(id)
        page = @pages[id]
        finish_button = self.button_for_function(:finish).id
        next_button = self.button_for_function(:next).id
        (mb = StringIO.new) << <<-ONE
  def #{page.name}
    @step = :#{id}
    @wizard = wizard_config
    @title = '#{page.title}'
    @description = '#{page.description}'
    h = (flash[:wizard_model]||{}).merge(params[:#{self.model}] || {}) 
    @#{self.model} = #{self.model_class_name}.new(h)
    flash[:wizard_model] = h
    button_id = check_action_for_button
    return if performed?
    if request.get?
      return if callback_performs_action?(:on_get_#{id}_page)
      render_wizard_page
      return
    end

    @#{self.model}.enable_validation_group :#{id}
    unless @#{self.model}.valid?
      return if callback_performs_action?(:on_#{id}_page_errors)
      render_wizard_page
      return
    end

        ONE
        if self.last_page?(id)
          mb << <<-TWO
    return if _on_wizard_#{finish_button}
    redirect_to #{Utils.formatted_redirect(self.completed_redirect)}
  end
        TWO
        elsif self.first_page?(id)
          mb << <<-THREE
    return _on_wizard_#{finish_button} if button_id == :#{finish_button}
    session[:progression] = [:#{id}]
    return if callback_performs_action?(:on_#{id}_page_#{next_button})
    redirect_to :action=>:#{self.next_page(id)}
  end
        THREE
        else
          mb << <<-FOUR
    return _on_wizard_#{finish_button} if button_id == :#{finish_button}
    session[:progression].push(:#{id})
    return if callback_performs_action?(:on_#{id}_page_#{next_button})
    redirect_to :action=>:#{self.next_page(id)}
  end
        FOUR
        end
        mb.string
      end

      def print_callbacks
        finish = self.button_for_function(:finish).id
        skip = self.button_for_function(:skip).id
        back = self.button_for_function(:back).id
        cancel = self.button_for_function(:cancel).id
      <<-CALLBACKS 
  protected
  def _on_wizard_#{finish}
    @#{self.model}.save_without_validation!
    flash.discard(:wizard_model)
    _wizard_final_redirect_to(:completed)
  end
  def _on_wizard_#{skip}
    redirect_to :action=>wizard_config.next_page(@step)
    true
  end
  def _on_wizard_#{back}
    redirect_to :action=>((session[:progression]||[]).pop || :#{self.page_order.first})
    true
  end
  def _on_wizard_#{cancel}
    _wizard_final_redirect_to(:canceled)
    true
  end
  def _wizard_final_redirect_to(which_redirect) 
    initial_referer = reset_wizard_session_vars
    redir = (which_redirect == :completed ? wizard_config.completed_redirect : wizard_config.canceled_redirect) || initial_referer
    return redirect_to(redir) if redir
    raise Wizardly::RedirectNotDefinedError, "No redirect was defined for completion or canceling the wizard.  Use :completed and :canceled options to define redirects.", caller
  end
  hide_action :_on_wizard_#{finish}, :_on_wizard_#{skip}, :_on_wizard_#{back}, :_on_wizard_#{cancel}, :_wizard_final_redirect_to
      CALLBACKS
      end

      def print_helpers
        next_id = self.button_for_function(:next).id
        finish_id = self.button_for_function(:finish).id
        first_page = self.page_order.first
      <<-HELPERS
  protected
  def guard_entry
    if (r = request.env['HTTP_REFERER'])
      h = ::ActionController::Routing::Routes.recognize_path(URI.parse(r).path)
      return if (h[:controller]||'') == '#{self.controller_name}'
      session[:initial_referer] = h
    else
      session[:initial_referer] = nil
    end
    flash.discard(:wizard_model)
    redirect_to :action=>:#{first_page} unless (params[:action] || '') == '#{first_page}'
  end   
  hide_action :guard_entry

  def render_wizard_page
  end
  hide_action :render_wizard_page

  def performed?; super; end
  hide_action :performed?

  def check_action_for_button
    button_id = nil
    #check if params[:commit] has returned a button from submit_tag
    unless (params[:commit] == nil)
      button_name = methodize_button_name(params[:commit])
      unless [:#{next_id}, :#{finish_id}].include?(button_id = button_name.to_sym)
        action_method_name = "on_" + params[:action].to_s + "_page_" + button_name
        unless callback_performs_action?(action_method_name)         
          method_name = "_on_wizard_" + button_name
          if (method = self.method(method_name))
            method.call
          else
            raise MissingCallbackError, "Callback method either '" + action_method_name + "' or '" + method_name + "' not defined", caller
          end
        end
      end
    end
    #add other checks here or above
    button_id
  end
  hide_action :check_action_for_button

  @wizard_callbacks ||= {}
  class << self
    attr_reader :wizard_callbacks
  end
  
  def callback_performs_action?(methId)
    wc = self.class.wizard_callbacks
    case wc[methId]
    when :none 
      return false
    when :found
    else #nil
      unless self.class.method_defined?(methId)
        wc[methId] = :none
        return false
      end
      wc[methId] = :found
    end
    self.__send__(methId)
    return self.performed?
  end    
  hide_action :callback_performs_action?

      HELPERS
      end
    end
  end
end
