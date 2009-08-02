
namespace :wizardly do
  desc "Display wizard configuration details"
  task :config => :environment do
    name = ENV['name']
    return print_usage unless name
    begin
      name = name.strip.camelize
      name += 'Controller' unless name.match('Controller$')
      controller = name.constantize
      begin
        c = controller.wizard_config
        begin
          puts
          puts c.print_config
        rescue Exception=>e
          puts "Problem printing configuration: " + e.message
        end
      rescue
        puts "{#{name}} is not a 'wizardly' controller.\nMake sure 'wizard_for_model' is defined in the controller class."
        puts
      end
    rescue
      puts "{#{name}} does not reference a controller class"
      puts
    end
  end
  
  def print_usage
    puts "Usage: rake wizardly:config name={controller_name}"
    puts
  end
end
