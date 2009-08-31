require File.dirname(__FILE__) + '/../spec_helper'
#require File.dirname(__FILE__) + '/../../app/controllers/callbacks_module'



describe Callbacks2Controller do

  it "should redirect when getting the init form" do
    get :init
    response.should redirect_to('/main/index#on_get_init_form')
  end
  it "should raise CallbackError when posting to :second form" do
    lambda { post :second }.should raise_error(Wizardly::CallbackError)
  end
  it "should redirect when posting next to the init page with empty fields" do
    post :init, {:next=>'Next'}
    response.should redirect_to('/main/index#on_invalid_init_form')
  end
  it "should redirect when posting next to the init page with valid fields" do
    post :init, {:commit=>'Next', :user=>{:first_name=>'john', :last_name=>'doe'}}
    response.should redirect_to('/main/index#on_init_form_next')
  end
  it "should redirect when posting skip to init page" do
    post :init, {:commit=>'Skip'}
    response.should redirect_to('/main/index#on_init_form_skip')
  end
  it "should redirect when posting :back to init page" do
    post :init, {:commit=>'Back'}
    response.should redirect_to('/main/index#on_init_form_back')
  end
  it "should redirect when posting cancel to init page" do
    post :init, {:commit=>'Cancel'}
    response.should redirect_to('/main/index#on_init_form_cancel')
  end
  it "should redirect when posting finish to the finish page" do
    post :finish, {:commit=>'Finish', :user=>{:username=>'johndoe', :password=>'password', :password_confirmation=>'password'}}
    response.should redirect_to('/main/index#on_finish_form_finish')
  end
end

