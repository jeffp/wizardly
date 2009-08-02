require File.dirname(__FILE__) + '/../spec_helper'

module TestVariables
  def init_page; "init"; end
  def second_page; "second"; end
  def third_page; "third"; end
  def finish_page; "finish"; end
  def blank_error; "*can't be blank"; end
  def back_button; "back"; end
  def next_button; "next"; end
  def skip_button; "skip"; end
  def finish_button; "finish"; end
  def cancel_button; "cancel"; end
  def field_first_name; "john"; end
  def field_last_name; "doe"; end
  def field_age; 30; end
  def field_programmer; true; end
  def field_status; "active"; end
  def field_gender; "male"; end
  def field_password; "password"; end
  def field_password_confirmation; field_password; end
  def field_username; "johndoe"; end
  def index_page_path; '/callbacks/index'; end
  def finish_page_path; '/callbacks/finish'; end
  def second_page_path; '/callbacks/second'; end
  def third_page_path; '/callbacks/third'; end
  def init_page_path; '/callbacks/init'; end
  def main_finished_path; '/main/finished'; end
  def main_canceled_path; '/main/canceled'; end
end

describe CallbacksController do
  include TestVariables
  
  
  it "should flag on_get_init_page when calling GET on init action" do
    #visit index_page_path
    get 'init'
    #response.body.should include('ON_GET_INIT_PAGE')
    assigns["on_get_init_page"].should == true
  end
=begin
  it "should flash ON_INIT_PAGE_ERRORS when clicking next on init page with empty fields" do
    visit index_page_path
    click_button next_button
    current_url.should include(init_page_path)
    response.body.should include('ON_INIT_PAGE_ERRORS')
  end
  it "should flash ON_INIT_PAGE_NEXT when clicking next on valid init page" do
    visit index_page_path
    fill_in(/first_name/, :with=>field_first_name)
    fill_in(/last_name/, :with=>field_last_name)
    click_button next_button
    current_url.should include(second_page_path)
    response.body.should include('ON_INIT_PAGE_NEXT')
  end
  it "should flash ON_INIT_PAGE_SKIP, ON_GET_SECOND_PAGE when clicking skip on init page" do
    visit index_page_path
    click_button skip_button
    current_url.should include(second_page_path)
    response.body.should include('ON_INIT_PAGE_SKIP')
    response.body.should include('ON_GET_SECOND_PAGE')
  end
  it "should flash ON_SECOND_PAGE_BACK when clicking back from second page" do
    visit index_page_path
    fill_in(/first_name/, :with=>field_first_name)
    fill_in(/last_name/, :with=>field_last_name)
    click_button next_button
    current_url.should include(second_page_path)
    click_button back_button
    current_url.should include(init_page_path)
    response.body.should include('ON_SECOND_PAGE_BACK')
    response.body.should include('ON_GET_INIT_PAGE')
  end
=end
  
end
