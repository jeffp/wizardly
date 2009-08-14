require File.dirname(__FILE__) + '/../spec_helper'
require 'four_step_helpers'

module TestVariables
  def init_page; "init"; end
  def second_page; "second"; end
  def third_page; "third"; end
  def finish_page; "finish"; end
  def blank_error; "can't be blank"; end
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
  def index_page_path; '/sandbox/index'; end
  def finish_page_path; '/sandbox/finish'; end
  def second_page_path; '/sandbox/second'; end
  def init_page_path; '/sandbox/init'; end
  def main_finished_path; '/main/finished'; end
  def main_canceled_path; '/main/canceled'; end
end

#testing :form_data=>:sandbox
describe "SandboxController" do
  include TestVariables
  include FourStepHelpers

  it "should fill in first page, navigate with link and return to first page with empty fields" do
    step_to_init_page
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
    fill_in_init_page
    click_button cancel_button
    click_link 'sandbox' #visit index_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end

  it "should fill in first page, leave and navigate with link to first page with empty fields" do
    step_to_init_page
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
    fill_in_init_page
    click_button cancel_button
    click_link 'sandbox' #visit index_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end
  
  it "should fill in first page, post, leave and navigate with link to first page with empty fields" do
    step_to_init_page
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
    fill_in_init_page
    click_button next_button
    current_url.should include(second_page)
    click_button cancel_button
    current_url.should include('main')
    click_link 'sandbox' #visit index_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end
  
  it "should fill in second page, post, leave and navigate with link to init when trying to return to second page" do
    step_to_second_page
    current_url.should include(second_page)
    field_with_id(/age/).value.should be_blank
    field_with_id(/gender/).value.should be_blank
    fill_in_second_page
    click_button next_button
    current_url.should include(third_page)
    click_button cancel_button
    current_url.should include('main')
    click_link 'sandbox_second' #visit second_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end
  
  it "should fill in first page, navigate with url and return to first page with empty fields" do
    step_to_init_page
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
    fill_in_init_page
    click_button cancel_button
    visit index_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end

  it "should fill in first page, leave and navigate with url to first page with empty fields" do
    step_to_init_page
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
    fill_in_init_page
    click_button cancel_button
    visit index_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end
  
  it "should fill in first page, post, leave and navigate with url to first page with empty fields" do
    step_to_init_page
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
    fill_in_init_page
    click_button next_button
    current_url.should include(second_page)
    click_button cancel_button
    current_url.should include('main')
    visit index_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end
  
  it "should fill in second page, post, leave and navigate with url to init when trying to return to second page" do
    step_to_second_page
    current_url.should include(second_page)
    field_with_id(/age/).value.should be_blank
    field_with_id(/gender/).value.should be_blank
    fill_in_second_page
    click_button next_button
    current_url.should include(third_page)
    click_button cancel_button
    current_url.should include('main')
    visit second_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end
  
  it "should skip first page and return to first page when back clicked on second page" do
    step_to_init_page
    fill_in_init_page
    click_button skip_button
    current_url.should include(second_page)
    click_button back_button
    current_url.should include(init_page)
    #field_with_id(/first/).value.should be_blank
    #field_with_id(/last/).value.should be_blank    
  end
  
  it "should skip the second page and return to init page when back clicked on third page" do
    step_to_second_page
    fill_in_second_page
    click_button skip_button
    current_url.should include(third_page)
    click_button back_button
    current_url.should include(init_page)
  end
  
  it "should skip both init and second page and return to init page when back clicked on third page" do
    step_to_init_page
    click_button skip_button
    current_url.should include(second_page)
    click_button skip_button
    current_url.should include(third_page)
    click_button back_button
    current_url.should include(init_page)
  end
  
  it "should skip third and return to second when back pressed on finish page" do
    step_to_third_page
    current_url.should include(third_page)
    click_button skip_button
    current_url.should include(finish_page)
    click_button back_button
    current_url.should include(second_page)
  end
  
end
