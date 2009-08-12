module DataModesHelper
  
  def wizardly_submit
    @@wizardly_submit ||= {}
    unless @@wizardly_submit[@step]
      buttons = @wizard.pages[@step].buttons
      @@wizardly_submit[@step] = buttons.inject(StringIO.new) do |io, button|
        io << submit_tag(button.name)
      end.string
    end
    @@wizardly_submit[@step]
  end
  
end
