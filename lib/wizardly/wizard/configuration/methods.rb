module Wizardly
  module Wizard
    class Configuration
      
      def print_callback_macros
        macros = [ 
          %w(on_post on_post_%s_form),
          %w(on_get on_get_%s_form),
          %w(on_errors on_invalid_%s_form)
        ]
        self.buttons.each do |id, button|
          macros << ['on_'+ id.to_s, 'on_%s_form_'+ id.to_s ]
        end
        mb = StringIO.new
        macros.each do |macro|
          mb << <<-MACRO
  def self.#{macro.first}(*args, &block)
    return if args.empty?
    all_forms = #{page_order.inspect}
    if args.include?(:all)
      forms = all_forms
    else
      forms = args.map do |fa|
        unless all_forms.include?(fa)
          raise(ArgumentError, ":"+fa.to_s+" in callback #{macro.first} is not a form defined for the wizard", caller)
        end
        fa
      end
    end
    forms.each do |form|
      self.send(:define_method, sprintf("#{macro.last}", form.to_s), &block )
    end
  end
MACRO
        end
        mb.string
      end
      
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
      
      def persist_key; 
        @persist_key ||= "wizardly_#{controller_name.to_s.underscore}_#{model}".to_sym 
      end      
    
      def print_page_action_method(id)
        page = @pages[id]
        finish_button = self.button_for_function(:finish).id
        next_button = self.button_for_function(:next).id
        (mb = StringIO.new) << <<-ONE
  def #{page.name}
    begin
      @step = :#{id}
      @wizard = wizard_config
      @title = '#{page.title}'
      @description = '#{page.description}'
      h = (self.wizard_form_data||{}).merge(params[:#{self.model}] || {}) 
      @#{self.model} = build_wizard_model(h)
      if request.post? && callback_performs_action?(:on_post_#{id}_form)
        raise CallbackError, "render or redirect not allowed in :on_post_#{id}_form callback", caller
      end
      button_id = check_action_for_button
      return if performed?
      if request.get?
        return if callback_performs_action?(:on_get_#{id}_form)
        render_wizard_form
        return
      end

      # @#{self.model}.enable_validation_group :#{id}
      unless @#{self.model}.valid?(:#{id})
        return if callback_performs_action?(:on_invalid_#{id}_form)
        render_wizard_form
        return
      end

        ONE
        if self.last_page?(id)
          mb << <<-TWO
      callback_performs_action?(:on_#{id}_form_#{finish_button})
      _on_wizard_#{finish_button}
      redirect_to #{Utils.formatted_redirect(self.completed_redirect)} unless self.performed?
        TWO
        elsif self.first_page?(id)
          mb << <<-THREE
      if button_id == :#{finish_button}
        callback_performs_action?(:on_#{id}_form_#{finish_button})
        _on_wizard_#{finish_button} if button_id == :#{finish_button}
        redirect_to #{Utils.formatted_redirect(self.completed_redirect)} unless self.performed?
        return
      end
      save_wizard_model! if wizard_config.persist_model_per_page?
      session[:progression] = [:#{id}]
      return if callback_performs_action?(:on_#{id}_form_#{next_button})
      redirect_to :action=>:#{self.next_page(id)}
        THREE
        else
          mb << <<-FOUR
      if button_id == :#{finish_button}
        callback_performs_action?(:on_#{id}_form_#{finish_button})
        _on_wizard_#{finish_button} if button_id == :#{finish_button}
        redirect_to #{Utils.formatted_redirect(self.completed_redirect)} unless self.performed?
        return
      end
      save_wizard_model! if wizard_config.persist_model_per_page?
      session[:progression].push(:#{id})
      return if callback_performs_action?(:on_#{id}_form_#{next_button})
      redirect_to :action=>:#{self.next_page(id)}
        FOUR
        end
        
        mb << <<-ENSURE
    ensure
      self.wizard_form_data = h.merge(@#{self.model}.attributes) if (@#{self.model} && !@completed)
    end
  end        
ENSURE
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
    @completed = true
    reset_wizard_form_data
    _wizard_final_redirect_to(:completed)
  end
  def _on_wizard_#{skip}
    redirect_to(:action=>wizard_config.next_page(@step)) unless self.performed?
  end
  def _on_wizard_#{back}
    # TODO: fix progression management
    redirect_to(:action=>((session[:progression]||[]).pop || :#{self.page_order.first})) unless self.performed?
  end
  def _on_wizard_#{cancel}
    _wizard_final_redirect_to(:canceled)
  end
  def _wizard_final_redirect_to(which_redirect) 
    initial_referer = reset_wizard_session_vars
    unless self.performed?
      redir = (which_redirect == :completed ? wizard_config.completed_redirect : wizard_config.canceled_redirect) || initial_referer
      return redirect_to(redir) if redir
      raise Wizardly::RedirectNotDefinedError, "No redirect was defined for completion or canceling the wizard.  Use :completed and :canceled options to define redirects.", caller
    end
  end
  hide_action :_on_wizard_#{finish}, :_on_wizard_#{skip}, :_on_wizard_#{back}, :_on_wizard_#{cancel}, :_wizard_final_redirect_to
      CALLBACKS
      end

      def print_helpers
        next_id = self.button_for_function(:next).id
        finish_id = self.button_for_function(:finish).id
        first_page = self.page_order.first
        guard_line = @guard_entry ? '' : 'return #guard entry disabled'
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
    if wizard_config.form_data_keep_in_session?
      return if self.wizard_form_data  # if it has an id we've started a wizard
    else
      reset_wizard_form_data 
    end
    #{guard_line}
    redirect_to :action=>:#{first_page} unless (params[:action] || '') == '#{first_page}'
  end
  hide_action :guard_entry

  def save_wizard_model!
    @#{self.model}.save_without_validation!
    if wizard_config.form_data_keep_in_session?
      h = self.wizard_form_data
      h['id'] = @#{self.model}.id
      self.wizard_form_data= h
    end
  end
  def build_wizard_model(params)
    if (wizard_config.persist_model_per_page? && (model_id = params['id']))
      _model = #{self.model_class_name}.find(model_id)
      _model.attributes = params
      _model
    else
      #{self.model_class_name}.new(params)
    end
  end
  hide_action :build_wizard_model, :save_wizard_model!

  def wizard_form_data=(hash)
    if wizard_config.form_data_keep_in_session?
      session[:#{self.persist_key}] = hash
    else
      if hash
        flash[:#{self.persist_key}] = hash
      else
        flash.discard(:#{self.persist_key})
      end
    end
  end

  def reset_wizard_form_data; self.wizard_form_data = nil; end
  def wizard_form_data
    wizard_config.form_data_keep_in_session? ? session[:#{self.persist_key}] : flash[:#{self.persist_key}]
  end
  hide_action :wizard_form_data, :wizard_form_data=, :reset_wizard_form_data

  def render_wizard_form
  end
  hide_action :render_wizard_form

  def performed?; super; end
  hide_action :performed?

  def check_action_for_button
    button_id = nil
    #check if params[:commit] has returned a button from submit_tag
    unless (params[:commit] == nil)
      button_name = methodize_button_name(params[:commit])
      unless [:#{next_id}, :#{finish_id}].include?(button_id = button_name.to_sym)
        action_method_name = "on_" + params[:action].to_s + "_form_" + button_name
        callback_performs_action?(action_method_name)
        method_name = "_on_wizard_" + button_name
        if (self.method(method_name))
          self.__send__(method_name)
        else
          raise MissingCallbackError, "Callback method either '" + action_method_name + "' or '" + method_name + "' not defined", caller
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
  
  def callback_performs_action?(methId, arg=nil)
    return false unless self.methods.include?(methId.to_s)
    #self.__send__(methId)
    self.method(methId).call
    self.performed?
  end
  hide_action :callback_performs_action?

      HELPERS
      end
    end
  end
end
