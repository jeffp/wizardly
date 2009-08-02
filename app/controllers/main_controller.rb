class MainController < ApplicationController
  def index
    @links = {
      :macro=>'/macro',
      :generated=>'/generated',
      :scaffold_test=>'/scaffold_test',
      :callbacks=>'/callbacks'
    }
  end

  def finished
    @referring_controller = referring_controller
  end

  def canceled
    @referring_controller = referring_controller
  end

  def referrer_page
  end
  
  private
  def referring_controller
    referer = request.env['HTTP_REFERER']    
    ActionController::Routing::Routes.recognize_path(URI.parse(referer).path)[:controller]
  end

end
