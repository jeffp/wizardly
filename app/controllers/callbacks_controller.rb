require 'wizardly'
class CallbacksController < ApplicationController 
  require 'callbacks_module'
  include Callbacks
  before_filter :init_flash_notice

  act_wizardly_for :four_step_user, :skip=>true, :mask_passwords=>[:password, :password_confirmation], 
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>{:controller=>:main, :action=>:canceled}
  
  def init_flash_notice; flash[:notice] = ''; end

  def flag(val)
    instance_variable_set("@#{val}", true)
    puts "--<<#{val}>>--"
#    flash[:notice] = flash[:notice] + "[#{val}]"
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

  flag_callback :on_get_init_page
  flag_callback :on_init_page_errors
  flag_callback :on_init_page_next
  flag_callback :on_init_page_finish
  flag_callback :on_init_page_back
  flag_callback :on_init_page_skip
  flag_callback :on_init_page_cancel
  
  flag_callback :on_get_second_page
  flag_callback :on_second_page_back
  flag_callback :on_second_page_next
  flag_callback :on_second_page_errors
  flag_callback :on_second_page_skip
  flag_callback :on_second_page_finish
  flag_callback :on_second_page_cancel
    
  flag_callback :on_get_finish_page
  #flag_callback :on_finish_page_errors
  flag_callback :on_finish_page_back
  flag_callback :on_finish_page_finish
  flag_callback :on_finish_page_next
  flag_callback :on_finish_page_cancel
  def on_finish_page_errors
    flag :on_finish_page_errors
    @four_step_user[:password] = ''
    @four_step_user[:password_confirmation] = ''
  end

  flag_callback :wizard_render_page
  

  chain_callback :_on_wizard_back
  chain_callback :_on_wizard_skip
  chain_callback :_on_wizard_cancel
  chain_callback :_on_wizard_finish
  
end
