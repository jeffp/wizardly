require File.dirname(__FILE__) + '/../spec_helper'
require 'step_helpers'

module TestVariables
  def init_page; "init"; end
  def second_page; "second"; end
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
  def index_page_path; '/data_modes2/index'; end
  def finish_page_path; '/data_modes2/finish'; end
  def second_page_path; '/data_modes2/second'; end
  def init_page_path; '/data_modes2/init'; end
  def main_finished_path; '/main/finished'; end
  def main_canceled_path; '/main/canceled'; end
end

#testing :persist_model=>:per_page, :form_data=>:sandbox
describe "DataModes2Controller" do
  include TestVariables
  include StepHelpers

  it "should save model incrementally" do
    User.delete_all
    step_to_finish_page
    u = User.find(:first)
    assert u
    u.first_name.should == field_first_name
    u.last_name.should == field_last_name
    step_to_finish_page
    v = User.find(:first)
    assert v
    v.first_name.should == field_first_name
    v.last_name.should == field_last_name
    v.age.should == field_age
    v.status.should == field_status
    v.programmer.should == field_programmer
    v.gender.should == field_gender    
    w = User.find(:all)
    w.size.should == 1
  end
  
  it "should complete wizard, save model, and create new model next time" do
    User.delete_all
    step_to_finish_page
    fill_in_finish_page
    click_button finish_button
    u = User.find(:first)
    assert u
    u.first_name.should == field_first_name
    u.password.should == field_password
    step_to_second_page
    w = User.find(:all)
    w.size.should == 2
    w.first.id.should_not == w.last.id
  end
  
  it "should fill in first page, leave and return to first page" do
    User.delete_all
    step_to_init_page
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
    fill_in_init_page
    click_button cancel_button
    visit init_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end
  
  it "should fill in second page, leave and return to init page when trying to return to second page directly" do
    User.delete_all
    step_to_second_page
    current_url.should include(second_page)
    field_with_id(/age/).value.should be_blank
    field_with_id(/status/).value.should be_blank
    fill_in_second_page
    click_button cancel_button
    visit '/data_modes/'+ second_page
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank    
    click_button next_button
  end

  
  it_should_behave_like "form data using sandbox"
  it_should_behave_like "all implementations"
  
end
