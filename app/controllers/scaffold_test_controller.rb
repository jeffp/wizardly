class ScaffoldTestController < ApplicationController #< WizardForModelController

  wizard_for_model :user, :skip=>true, :mask_passwords=>[:password, :password_confirmation],
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>{:controller=>:main, :action=>:canceled}
  
  
end
