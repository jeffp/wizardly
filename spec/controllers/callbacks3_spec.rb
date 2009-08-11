require File.dirname(__FILE__) + '/../spec_helper'


describe Callbacks3Controller do

  it "should redirect when getting all forms" do
    get :init
    response.should redirect_to('/main/index#on_get_all')
    get :second
    response.should redirect_to('/main/index#on_get_all')
    get :finish
    response.should redirect_to('/main/index#on_get_all')
  end
  it "should set the @on_post_init_form when posting to init form" do
    post :init
    assigns[:on_post_init_form].should == true
  end
  it "should raise CallbackError when posting to :second form" do
    lambda { post :second }.should raise_error(Wizardly::CallbackError)
  end
  it "should redirect when posting next to the init page with empty fields" do
    post :init, {:commit=>'Next'}
    response.should redirect_to('/main/index#on_invalid_init_form')
  end
  it "should redirect when posting next to the init page with valid fields" do
    post :init, {:commit=>'Next', :user=>{:first_name=>'john', :last_name=>'doe'}}
    response.should redirect_to('/main/index#on_init_form_next')
  end
  #skip
  it "should redirect when posting skip to init and finish page" do
    post :init, {:commit=>'Skip'}
    response.should redirect_to('/main/index#on_init_and_finish_form_skip')
    post :finish, {:commit=>'Skip'}
    response.should redirect_to('/main/index#on_init_and_finish_form_skip')
  end
  #back
  it "should redirect when posting :back to init, finish page" do
    post :init, {:commit=>'Back'}
    response.should redirect_to('/main/index#on_init_and_finish_form_back')
    post :finish, {:commit=>'Back'}
    response.should redirect_to('/main/index#on_init_and_finish_form_back')
  end
  #cancel
  it "should redirect when posting cancel to init, finish page" do
    post :init, {:commit=>'Cancel'}
    response.should redirect_to('/main/index#on_init_and_finish_form_cancel')
    post :finish, {:commit=>'Cancel'}
    response.should redirect_to('/main/index#on_init_and_finish_form_cancel')
  end
  it "should redirect when posting finish to the finish page" do
    post :finish, {:commit=>'Finish', :user=>{:username=>'johndoe', :password=>'password', :password_confirmation=>'password'}}
    response.should redirect_to('/main/index#on_finish_form_finish')
  end
end

