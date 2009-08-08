module Callbacks
  def button_callbacks
  [
    :on_get_init_page,
    :on_init_page_errors,
    :on_init_page_next,
    :on_init_page_finish,
    :on_init_page_back,
    :on_init_page_skip,
    :on_init_page_cancel,

    :on_get_second_page,
    :on_second_page_back,
    :on_second_page_next,
    :on_second_page_errors,
    :on_second_page_skip,
    :on_second_page_finish,
    :on_second_page_cancel,

    :on_get_finish_page,
    :on_finish_page_errors,
    :on_finish_page_back,
    :on_finish_page_skip,
    :on_finish_page_finish,
    :on_finish_page_next,
    :on_finish_page_cancel,
    
    :wizard_render_page
    ]
  end
  
  def wizard_callbacks
    [
    :_on_wizard_cancel,
    :_on_wizard_skip,
    :_on_wizard_back,
    :_on_wizard_finish
  ]
  end
  
end