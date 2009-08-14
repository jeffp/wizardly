class SessionController < ApplicationController
  act_wizardly_for :four_step_user, :redirect=>'/main/index', :form_data=>:session, :skip=>true

end