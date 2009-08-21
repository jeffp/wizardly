require 'wizardly'
class Callbacks2Controller < ApplicationController 
 
  act_wizardly_for :user, :skip=>true, :guard=>false, :mask_passwords=>[:password, :password_confirmation], 
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>'/main/canceled'#{:controller=>:main, :action=>:canceled}

  #NOTE: these only for testing - the preferred method of defining callbacks is
  # using the callback macros -- see Callbacks3Controller and the Readme.rdoc ;)
  def _on_post_second_form
    redirect_to '/main/index#on_post_second_form'
  end
  def _on_get_init_form
    redirect_to '/main/index#on_get_init_form'
  end
  def _on_invalid_init_form
    redirect_to '/main/index#on_invalid_init_form'
  end
  def _on_init_form_back
    redirect_to '/main/index#on_init_form_back'
  end
  def _on_init_form_cancel
    redirect_to '/main/index#on_init_form_cancel'
  end
  def _on_init_form_next
    redirect_to '/main/index#on_init_form_next'
  end
  def _on_init_form_skip
    redirect_to '/main/index#on_init_form_skip'
  end
  def _on_finish_form_finish
    redirect_to '/main/index#on_finish_form_finish'
  end
  hide_action :_on_post_second_form
  hide_action :_on_get_init_form
  hide_action :_on_invalid_init_form
  hide_action :_on_init_form_back
  hide_action :_on_init_form_cancel
  hide_action :_on_init_form_next
  hide_action :_on_init_form_skip
  hide_action :_on_finish_form_finish

end
