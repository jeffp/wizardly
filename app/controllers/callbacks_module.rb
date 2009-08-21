module Callbacks
  
#  on_errors(:second) do    
#  end
#  on_get(:second) do
#  end
#  on_post(:second) do
#  end
#  on_next(:second) do
#  end
#  on_cancel(:second) do
#  end
#  on_render do
#  end
#  on_cancel(:all) do
#  end
  
  def self.action_callbacks
  [
    :_on_get_init_form,
    :_on_post_init_form,
    :_on_invalid_init_form,
    :_on_init_form_next,
    :_on_init_form_finish,
    :_on_init_form_back,
    :_on_init_form_skip,
    :_on_init_form_cancel,

    :_on_get_second_porm,
    :_on_post_init_form,
    :_on_invalid_init_form,
    :_on_second_form_back,
    :_on_second_form_next,
    :_on_second_form_skip,
    :_on_second_form_finish,
    :_on_second_form_cancel,

    :_on_get_finish_form,
    :_on_post_finish_form,
    :_on_invalid_finish_form,
    :_on_finish_form_back,
    :_on_finish_form_skip,
    :_on_finish_form_finish,
    :_on_finish_form_next,
    :_on_finish_form_cancel,
    
    :wizard_render_form
    ]
  end
  
  def self.wizard_callbacks
    [
    :_on_wizard_cancel,
    :_on_wizard_skip,
    :_on_wizard_back,
    :_on_wizard_finish
  ]
  end
  
end