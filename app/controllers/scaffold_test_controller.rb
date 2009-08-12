class ScaffoldTestController < ApplicationController #< WizardForModelController

  wizard_for_model :user, :skip=>true, :form_data=>:sandbox, :mask_passwords=>[:password, :password_confirmation],
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>{:controller=>:main, :action=>:canceled}
  
  
end
