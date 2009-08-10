require 'wizardly'
class CallbacksController < ApplicationController 
  require 'callbacks_module'
 
  act_wizardly_for :user, :skip=>true, :guard=>false, :mask_passwords=>[:password, :password_confirmation], 
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>'/main/canceled'#{:controller=>:main, :action=>:canceled}
  

  def flag(val)
    instance_variable_set("@#{val}", true)
    #puts "--<<#{val}>>--"
  end
  
  def self.flag_callback(name)
    self.class_eval "def #{name}; flag :#{name}; end "
  end
  def self.chain_callback(name)
    self.class_eval <<-ERT
      alias_method :#{name}_orig, :#{name}
      def #{name}; flag :#{name}; #{name}_orig; end
    ERT
  end  
  Callbacks::action_callbacks.each {|cb| flag_callback cb }
#  def on_invalid_finish_form
#    flag :on_finish_page_errors
#    @user[:password] = ''
#    @user[:password_confirmation] = ''
#  end
  Callbacks::wizard_callbacks.each {|cb| chain_callback cb}  
  
end
