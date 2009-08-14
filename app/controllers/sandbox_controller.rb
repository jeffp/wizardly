class SandboxController < ApplicationController
  act_wizardly_for :four_step_user, :redirect=>'/main/index', :form_data=>:sandbox, :skip=>true

end