require File.dirname(__FILE__) + '/../spec_helper'
require 'step_helpers'

#require 'rails_generator'
#require 'rails_generator/scripts/generate'
#
#gen_argv = []
#gen_argv << "wizardly_controller" << "generated" << "user" << "/main/finished" << "/main/canceled" << "--force"
#Rails::Generator::Scripts::Generate.new.run(gen_argv)

#load 'app/controllers/generated_controller.rb'

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
  def index_page_path; '/generated/index'; end
  def finish_page_path; '/generated/finish'; end
  def second_page_path; '/generated/second'; end
  def init_page_path; '/generated/init'; end
  def main_finished_path; '/main/finished'; end
  def main_canceled_path; '/main/canceled'; end
end

describe "GeneratedController" do
  include TestVariables
  include StepHelpers
  
  it_should_behave_like "form data using session"
  it_should_behave_like "all implementations"
end

