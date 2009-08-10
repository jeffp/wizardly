require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../app/controllers/callbacks_module'

#include Callbacks


Spec::Matchers.define :have_callback do |*expected_callbacks|
  match do |value|
    Callbacks::action_callbacks.each do |b|
      value[b] == (expected_callbacks.include?(b) ? true : nil)
    end
    Callbacks::wizard_callbacks.each do |w|
      value[w] == (expected_callbacks.include?(w) ? true : nil)
    end
    true
  end
end


describe CallbacksController do

  it "should flag callbacks and render when requesting the init form" do
    get :init
    assigns.should have_callback(:on_get_init_form, :render_wizard_form)
  end
  it "should flag callbacks and re-render when posting next to the init page with empty fields" do
    post :init
    assigns.should have_callback(:on_post_init_form, :on_invalid_init_form, :render_wizard_form)
  end
  #should there be a _on_wizard_next
  it "should flag callbacks when posting next to the init page with valid fields" do
    post :init, {:commit=>'Next', :user=>{:first_name=>'john', :last_name=>'doe'}}
    response.should redirect_to(:action=>:second)
    assigns.should have_callback(:on_post_init_form, :on_init_form_next)
  end
  it "should flag callbacks and redirect to :second page when posting skip to init page" do
    post :init, {:commit=>'Skip', :user=>{:first_name=>'', :last_name=>''}}
    assigns.should have_callback(:on_post_init_form, :on_init_form_skip, :_on_wizard_skip)
    response.should redirect_to(:action=>:second)
  end
  it "should flag callbacks and redirect to :first page when posting :back to :second page" do
    post :second, {:commit=>'Back'}
    assigns.should have_callback(:on_post_second_form, :on_second_form_back, :_on_wizard_back)
    response.should redirect_to(:action=>:init)
  end
  it "should flag callbacks and redirect to :canceled page when posting cancel to second page" do
    post :second, {:commit=>'Cancel'}
    assigns.should have_callback(:on_post_second_form, :on_second_form_cancel, :_on_wizard_cancel)
    response.should redirect_to(:controller=>:main, :action=>:canceled)
  end
  it "should flag callbacks and redirect to :completed page when posting finish to the finish page" do
    post :finish, {:commit=>'Finish', :user=>{:username=>'johndoe', :password=>'password', :password_confirmation=>'password'}}
    assigns.should have_callback(:on_post_finish_form, :on_finish_form_finish, :_on_wizard_finish)
    response.should redirect_to(:controller=>:main, :action=>:finished)
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
