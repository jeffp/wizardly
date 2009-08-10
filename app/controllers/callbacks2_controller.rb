require 'wizardly'
class Callbacks2Controller < ApplicationController 
 
  act_wizardly_for :user, :skip=>true, :guard=>false, :mask_passwords=>[:password, :password_confirmation], 
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>'/main/canceled'#{:controller=>:main, :action=>:canceled}
  
  def on_post_second_form
    redirect_to '/main/index#on_post_second_form'
  end
  def on_get_init_form
    redirect_to '/main/index#on_get_init_form'
  end
  def on_invalid_init_form
    redirect_to '/main/index#on_invalid_init_form'
  end
  def on_init_form_back
    redirect_to '/main/index#on_init_form_back'
  end
  def on_init_form_cancel
    redirect_to '/main/index#on_init_form_cancel'
  end
  def on_init_form_next
    redirect_to '/main/index#on_init_form_next'
  end
  def on_init_form_skip
    redirect_to '/main/index#on_init_form_skip'
  end
  def on_finish_form_finish
    redirect_to '/main/index#on_finish_form_finish'
  end
  
end
