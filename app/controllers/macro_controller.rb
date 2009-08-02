class MacroController < ApplicationController

  act_wizardly_for :user, 
    :completed=>{:controller=>:main, :action=>:finished}, 
    :canceled=>{:controller=>:main, :action=>:canceled}  
  
end
