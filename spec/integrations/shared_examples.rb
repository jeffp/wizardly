
shared_examples_for "all implementations" do
  
  it "should reset form data when leaving wizard and returning" do
    step_to_finish_page
    click_button cancel_button
    click_link 'signup'
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end
  it "should save user when clicking finish on finish page" do
    User.delete_all
    step_to_finish_page
    fill_in_finish_page
    click_button finish_button
    current_url.should include(main_finished_path)
    (u = User.find(:first)).should_not be_nil
    u.first_name.should == field_first_name
    u.last_name.should == field_last_name
    u.age.should == field_age
    u.gender.should == field_gender
    u.programmer.should == field_programmer
    u.status.should == field_status
    u.username.should == field_username
    u.password.should == field_password
  end
  it "should back up to second page from finish page and maintain field data when back button clicked" do
    step_to_finish_page
    click_button back_button
    current_url.should include(second_page)
    field_with_id(/age/).value.should == field_age.to_s
    field_with_id(/gender/).value.should == field_gender
    field_with_id(/programmer/).value.should == (field_programmer ? "1":"0")
    field_with_id(/status/).value.should == field_status
  end
  it "should back up to init from second page and maintain field data when back button clicked" do
    step_to_second_page
    click_button back_button
    field_with_id(/first_name/).value.should == field_first_name
    field_with_id(/last_name/).value.should == field_last_name
  end
  it "should maintain field data after backing up then returning to page via next button" do
    step_to_second_page
    fill_in(/age/, :with=>field_age)
    fill_in(/gender/, :with=>field_gender)
    fill_in(/programmer/, :with=>'')
    fill_in(/status/, :with=>'')
    click_button back_button
    current_url.should include(init_page)
    click_button next_button
    field_with_id(/age/).value.should == field_age.to_s
    field_with_id(/gender/).value.should == field_gender
    field_with_id(/programmer/).value.should be_blank
    field_with_id(/status/).value.should be_blank
  end

  it "should redirect to referrer page when coming from referrer and cancelled from init page" do
  end
  it "should redirect to ..main/canceled when clicking cancel button on second page" do
    step_to_second_page
    click_button cancel_button
    current_url.should include(main_canceled_path)
  end
  it "should redirect to ..main/canceled when clicking cancel button on finish page" do
    step_to_finish_page
    click_button cancel_button
    current_url.should include(main_canceled_path)
    end
  it "should redirect to ..main/canceled when clicking cancel button on init page" do
    step_to_init_page
    click_button cancel_button
    current_url.should include(main_canceled_path)
  end
  it "should invalidate finish page with empty fields" do
    step_to_finish_page
    click_button finish_button
    current_url.should include(finish_page)
    response.body.should contain(blank_error)
  end
  it "should invalidate second page with empty fields" do
    step_to_second_page
    click_button next_button
    current_url.should include(second_page)
    response.body.should contain(blank_error)
  end
  it "should invalidate init page with empty fields" do
    visit init_page_path
    click_button next_button
    current_url.should include(init_page)
    response.body.should include(blank_error)
  end
  it "should redirect to init page if entering from finish page" do
    visit finish_page_path
    current_url.should include(init_page)
  end
  it "should redirect to init page if entering from second page" do
    visit second_page_path
    current_url.should include(init_page)
  end
  it "should start at init page and fields should be empty when entering from index" do
    visit index_page_path
    current_url.should include(init_page)
    field_with_id(/first/).value.should be_blank
    field_with_id(/last/).value.should be_blank
  end
  it "should navigate from init to second screen on next button without validation errors" do
    User.delete_all
    step_to_second_page
    current_url.should include(second_page)
  end
  it "should go from init to finish screen on next buttons without validation errors" do
    User.delete_all
    step_to_finish_page
    current_url.should include(finish_page)
  end
  it "should complete form and save User object on completion without validation errors" do
    User.delete_all
    step_to_finish_page
    fill_in_finish_page
    click_button finish_button
    current_url.should include(main_finished_path)
    User.find_by_username(field_username).should_not be_nil
  end
  

  private #refactored helpers
  def step_to_init_page
    visit init_page_path
  end
  def fill_in_init_page
    fill_in(/first_name/, :with=>field_first_name)
    fill_in(/last_name/, :with=>field_last_name)
  end
  def step_to_second_page
    step_to_init_page
    fill_in_init_page
    click_button next_button
  end
  def fill_in_second_page
    fill_in(/age/, :with=>field_age)
    fill_in(/gender/, :with=>field_gender)
    fill_in(/status/, :with=>field_status)
    fill_in(/programmer/, :with=>field_programmer)
  end
  def step_to_finish_page
    step_to_second_page
    fill_in_second_page
    click_button next_button
  end
  def fill_in_finish_page
    fill_in(/username/, :with=>field_username)
    fill_in("user[password]", :with=>field_password)
    fill_in("user[password_confirmation]", :with=>field_password_confirmation)
  end
  
end
