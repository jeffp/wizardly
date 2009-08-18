class ImageSubmitController < ApplicationController
  wizard_for_model :user, :redirect=>'/main/index', :skip=>true
end
