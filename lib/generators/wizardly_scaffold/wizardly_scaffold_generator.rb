#require 'wizardly'

class WizardlyScaffoldGenerator < Rails::Generator::Base
  attr_reader :wizard_config, :pages
  attr_reader :controller_name,
              :controller_class_path,
              :controller_file_path,
              :controller_class_nesting,
              :controller_class_nesting_depth,
              :controller_class_name,
              :controller_underscore_name            
  attr_reader :model_name, :view_file_ext
  
  alias_method :controller_file_name, :controller_underscore_name
  
  def initialize(runtime_args, runtime_options = {})
    super
    name = @args[0].sub(/^:/, '').underscore.sub(/_controller$/, '').camelize + 'Controller'
    
    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(name)
    @controller_class_name_without_nesting = base_name.camelize
    @controller_underscore_name = base_name.underscore
    @controller_name = @controller_underscore_name.sub(/_controller$/, '')
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
    
    begin
      @controller_class = @controller_class_name.constantize 
    rescue Exception => e
      raise Wizardly::WizardlyScaffoldError, "No controller #{@controller_class_name} found: " + e.message, caller
    end
    begin
      @wizard_config = @controller_class.wizard_config
    rescue
      raise Wizardly::WizardlyScaffoldError, "#{@controller_class_name} must have a valid 'wizard_for_model' declaration", caller
    end
    
    @pages = @wizard_config.pages
    @model_name = @wizard_config.model
    
    #based on options, default is --html, others --ajax, --haml
    @view_file_ext = "html.erb"
  end
  
  def manifest
    record do |m|
      # Helper, views, test and stylesheets directories.
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_name))
      m.directory(File.join('app/views/layouts', controller_class_path))
      #m.directory(File.join('test/functional', controller_class_path))
      #m.directory(File.join('public/stylesheets', class_path))

      pages.each do |id, page|
        m.template(
          "form.#{view_file_ext}",
          File.join('app/views', controller_class_path, controller_name, "#{id}.#{view_file_ext}"),
          :assigns=>{:id=>id, :page=>page}
        )
      end
      
      m.template("helper.rb.erb", File.join('app/helpers', controller_class_path, "#{controller_name}_helper.rb"))

      # Layout and stylesheet.
      m.template("layout.#{view_file_ext}", File.join('app/views/layouts', controller_class_path, "#{controller_name}.#{view_file_ext}"))
      m.template('style.css', 'public/stylesheets/scaffold.css')

      #m.dependency 'model', [name] + @args, :collision => :skip
    end
  end
  
  protected
  def banner
    "Usage: #{$0} wizardly_scaffold controller_name --ajax --haml"
  end
  
  def extract_modules(name)
    modules = name.include?('/') ? name.split('/') : name.split('::')
    name    = modules.pop
    path    = modules.map { |m| m.underscore }
    file_path = (path + [name.underscore]).join('/')
    nesting = modules.map { |m| m.camelize }.join('::')
    [name, path, file_path, nesting, modules.size]
  end
  
  
end
