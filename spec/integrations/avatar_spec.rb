require File.dirname(__FILE__) + '/../spec_helper'
require 'avatar_step_helpers'

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
  def field_avatar; File.dirname(__FILE__) + '/../../public/images/avatar.png'; end;
  def main_finished_path; '/main/finished'; end
  def main_canceled_path; '/main/canceled'; end
end

describe "AvatarSessionController" do
  include TestVariables
  include AvatarStepHelpers
  def index_page_path; '/avatar_session/index'; end
  def finish_page_path; '/avatar_session/finish'; end
  def second_page_path; '/avatar_session/second'; end
  def init_page_path; '/avatar_session/init'; end

  it "should accept avatar field" do
    step_to_second_page
    fill_in_second_page
    click_button next_button
  end

  it "should accept and save avatar field" do
    User.delete_all
    step_to_finish_page
    fill_in_finish_page
    click_button finish_button
    u = AvatarUser.find_by_username(field_username)
    u.should_not be_nil
    u.first_name.should == field_first_name
    u.avatar_file_name.should include('avatar.png')
    u.avatar_file_size.should_not == 0
    u.avatar_content_type.should == 'image/png'
  end

  it "should not reset form data when leaving wizard and returning" do
    step_to_finish_page
    click_button cancel_button
    click_link 'signup'
    current_url.should include(init_page)
    field_with_id(/first/).value.should == field_first_name
    field_with_id(/last/).value.should == field_last_name
    click_button next_button
    field_with_id(/age/).value.should == field_age.to_s
    field_with_id(/gender/).value.should == field_gender
    field_with_id(/programmer/).value.should == (field_programmer ? "1":"0")
    field_with_id(/status/).value.should == field_status
  end
end
