require File.dirname(__FILE__) + '/../test_helper'

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

class CallbacksControllerTest < ActionController::TestCase
  include TestVariables
  
#  def test_should_flag_on_get_init_page_when_calling_get_on_init_action
#    get init_page
#    assert_response :success
#    assert assigns['on_get_init_page']
#  end
#  def test_should_flag_on_init_page_errors_when_clicking_next_on_init_page_with_empty_fields
#    post init_page, :commit=>next_button
#    assert_template init_page
#    assert assigns['on_init_page_errors']
#  end
  def test_should_flag_ON_INIT_PAGE_NEXT_when_clicking_next_on_valid_init_page
    post :init, :user=>{:first_name=>field_first_name, :last_name=>field_last_name}, :commit=>:next
    #assert_redirected_to :action=>second_page
    assert assigns['on_init_page_next']
  end
#  def test_should_flag_ON_INIT_PAGE_SKIP_when_clicking_skip_on_init_page
#    post init_page, :commit=>skip_button
#    assert_redirected_to :action=>second_page
#    assert assigns['on_init_page_skip']
#  end
#  def test_should_flag_ON_SECOND_PAGE_BACK_when_clicking_back_from_second_page
#    post init_page, :user=>{:first_name=>field_first_name, :last_name=>field_last_name}, :commit=>next_button
#    #assert_redirected_to :action=>second_page
#    post second_page, :user=>{:age=>field_age.to_s, :gender=>field_gender}, :commit=>back_button
#    #assert_redirected_to :action=>init_page
#    assert assigns['on_second_page_back']
#  end
end
