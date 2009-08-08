require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../app/controllers/callbacks_module'

include Callbacks


Spec::Matchers.define :have_callback do |*expected_callbacks|
  match do |value|
    button_callbacks.each do |b|
      return false unless value[b] == (expected_callbacks.include?(b) ? true : nil)
    end
    wizard_callbacks.each do |w|
      return false unless value[w] == (expected_callbacks.include?(w) ? true : nil)
    end
    true
  end
end


describe CallbacksController do

  it "should flag before_get_init_page and on_get_init_page when calling GET on init action" do
    get :init
    assigns.should have_callback(:after_get_init_page, :before_get_init_page, :render_wizard_page)
  end
  it "should flag on_init_page_errors when clicking next on init page with empty fields" do
    post :init
    assigns.should have_callback(:on_invalid_init_page, :before_post_init_page, :render_wizard_page)
  end
  it "should flag on_init_page_next when clicking next on valid init page" do
    post :init, {:commit=>'Next', :four_step_user=>{:first_name=>'john', :last_name=>'doe'}}
    response.should redirect_to(:action=>:second)
    assigns.should have_callback(:after_post_init_page, :before_post_init_page)
  end
  it "should flag on_init_page_skip, _on_wizard_skip and redirect to :second page when posting skip to init page" do
    post :init, {:commit=>'Skip'}
    assigns.should have_callback(:before_post_init_page, :on_init_page_skip, :_on_wizard_skip)
    response.should redirect_to(:action=>:second)
  end
  it "should flag on_second_page_back when posting :back to :second page" do
    post :second, {:commit=>'Back'}
    assigns.should have_callback(:before_post_init_page, :on_second_page_back, :_on_wizard_back)
    response.should redirect_to(:action=>:init)
  end
  it "should flag before_post_second_page and on_second_page_cancel when canceling on second page" do
    post :second, {:commit=>'Cancel'}
    assigns.should have_callback(:before_post_second_page, :on_second_page_cancel, :_on_wizard_cancel)
    response.should redirect_to(:controller=>:main, :action=>:canceled)
  end
  it "should flag before_post, after_post and finished for finishing the finish page" do
    post :finish, {:commit=>'Finish'}
    assigns.should have_callback(:before_post_finish_page, :after_post_finish_page, :on_finish_page_finish)
    response.should redirect_to(:controller=>:main, :action=>:completed)
  end
end


#module TestVariables
#  def init_page; "init"; end
#  def second_page; "second"; end
#  def third_page; "third"; end
#  def finish_page; "finish"; end
#  def blank_error; "*can't be blank"; end
#  def back_button; "back"; end
#  def next_button; "next"; end
#  def skip_button; "skip"; end
#  def finish_button; "finish"; end
#  def cancel_button; "cancel"; end
#  def field_first_name; "john"; end
#  def field_last_name; "doe"; end
#  def field_age; 30; end
#  def field_programmer; true; end
#  def field_status; "active"; end
#  def field_gender; "male"; end
#  def field_password; "password"; end
#  def field_password_confirmation; field_password; end
#  def field_username; "johndoe"; end
#  def index_page_path; '/callbacks/index'; end
#  def finish_page_path; '/callbacks/finish'; end
#  def second_page_path; '/callbacks/second'; end
#  def third_page_path; '/callbacks/third'; end
#  def init_page_path; '/callbacks/init'; end
#  def main_finished_path; '/main/finished'; end
#  def main_canceled_path; '/main/canceled'; end
#end
