class DataModesController < ApplicationController

  act_wizardly_for :user, :persist_model=>:per_page, :form_data=>:session,
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>{:controller=>:main, :action=>:canceled}  
  
end
