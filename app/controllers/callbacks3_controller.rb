require 'wizardly'
class Callbacks3Controller < ApplicationController 
 
  act_wizardly_for :user, :skip=>true, :guard=>false, :mask_passwords=>[:password, :password_confirmation], 
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>'/main/canceled'#{:controller=>:main, :action=>:canceled}

  on_post(:second) do
    redirect_to '/main/index#on_post_second_form'
  end
  on_post(:init) do
    @on_post_init_form = true
  end
  on_get(:all) do
    redirect_to '/main/index#on_get_all'
  end
  on_errors(:init) do
    redirect_to '/main/index#on_invalid_init_form'
  end
  on_back(:init, :finish) do
    redirect_to '/main/index#on_init_and_finish_form_back'
  end
  on_cancel(:init, :finish) do
    redirect_to '/main/index#on_init_and_finish_form_cancel'
  end
  on_next(:init) do
    redirect_to '/main/index#on_init_form_next'
  end
  on_skip(:init, :finish) do
    redirect_to '/main/index#on_init_and_finish_form_skip'
  end
  on_finish(:finish) do
    redirect_to '/main/index#on_finish_form_finish'
  end
  
end
