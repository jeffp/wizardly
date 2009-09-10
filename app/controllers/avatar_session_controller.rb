require 'wizardly'
class AvatarSessionController < ApplicationController
  #tests paperclip
  act_wizardly_for :user_avatar, :form_data=>:session, :persist_model=>:per_page,
    :completed=>{:controller=>:main, :action=>:finished},
    :canceled=>{:controller=>:main, :action=>:canceled}  

    
end
