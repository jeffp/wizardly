# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'validation_group'
require 'wizardly'
require 'spec/autorun'
require 'spec/rails'

require 'spec/integrations/shared_examples'
require 'spec/integrations/matchers'

Webrat.configure do |config|
  config.mode = :rails
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
#  config.use_transactional_fixtures = true
#  config.use_instantiated_fixtures  = false
#  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

#setup for integrating webrat with rspec
module Spec::Rails::Example
  class IntegrationExampleGroup < ActionController::IntegrationTest
    
    def initialize(defined_description, options={}, &implementation)
      defined_description.instance_eval do
        def to_s
          self
        end
      end
      super(defined_description)
    end
    
    Spec::Example::ExampleGroupFactory.register(:integration, self)
  end
end
