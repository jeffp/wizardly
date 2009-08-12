module StepHelpers
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