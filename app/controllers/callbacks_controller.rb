class CallbacksController < ApplicationController #< WizardForModelController
  before_filter :init_flash_notice

#  wizard_for_model :four_step_user, :skip=>true, :mask_passwords=>[:password, :password_confirmation], 
#    :completed=>{:controller=>:main, :action=>:finished}, 
#    :canceled=>{:controller=>:main, :action=>:canceled}
  
  def init_flash_notice; flash[:notice] = ''; end

  def flag(val)
    instance_variable_set("@#{val}", true)
    puts "--<<#{val}>>--"
#    flash[:notice] = flash[:notice] + "[#{val}]"
  end
  
  def on_get_init_page; flag :on_get_init_page; end
  def on_init_page_errors; flag :on_init_page_errors; end
  def on_init_page_next; flag :on_init_page_next; end
  def on_init_page_skip; flag :on_init_page_skip; end
  def on_init_page_cancel; flag :on_init_page_cancel; end
  
  def on_get_second_page; flag :on_get_second_page; end
  def on_second_page_back; flag :on_second_page_back; end
  def on_second_page_next; flag :on_second_page_next; end
  def on_second_page_errors; flag :on_second_page_errors; end
  def on_second_page_skip; flag :on_second_age_skip; end
  def on_second_page_cancel; flag :on_second_page_cancel; end
  
  def wizard_render_page; flag :wizard_render_page; end
  
  def on_finish_page_errors
    flag :on_finish_page_errors
    @four_step_user[:password] = ''
    @four_step_user[:password_confirmation] = ''
  end
  
end
