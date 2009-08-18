class DataModes2Controller < ApplicationController

  act_wizardly_for :user, :persist_model=>:per_page, :form_data=>:sandbox,
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>{:controller=>:main, :action=>:canceled}  
  
end
