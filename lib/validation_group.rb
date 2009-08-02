# Validation group code from Alex Kira's repository of validationgroup on Github
# modifications made for wizardly integration
# included herein until such time the code can be managed and released independantly with modifications
module ValidationGroup
  module ActiveRecord
    module ActsMethods # extends ActiveRecord::Base
      def self.extended(base)
        # Add class accessor which is shared between all models and stores
        # validation groups defined for each model
        base.class_eval do
          cattr_accessor :validation_group_classes
          self.validation_group_classes = {}
					
					def self.validation_group_order; @validation_group_order; end
					def self.validation_groups(all_classes = false)
						return (self.validation_group_classes[self] || {}) unless all_classes
						klasses = ValidationGroup::Util.current_and_ancestors(self).reverse
						returning Hash.new do |hash|
							klasses.each do |klass|
								hash.merge! self.validation_group_classes[klass]
							end
						end
					end
        end
      end

      def validation_group(name, options={})
        self_groups = (self.validation_group_classes[self] ||= {})
        self_groups[name.to_sym] = options[:fields] || []
				@validation_group_order ||= []
				@validation_group_order << name.to_sym

        unless included_modules.include?(InstanceMethods)
          attr_reader :current_validation_group, :current_validation_fields
          include InstanceMethods
					alias_method_chain :valid?, :validation_group
        end
      end
    end

    module InstanceMethods # included in every model which calls validation_group
			
      def enable_validation_group(group)
        # Check if given validation group is defined for current class
        # or one of its ancestors
        group_classes = self.class.validation_group_classes
        found = ValidationGroup::Util.current_and_ancestors(self.class).
					find do |klass|
						group_classes[klass] && group_classes[klass].include?(group)
					end
        if found
          @current_validation_group = group
					@current_validation_fields = group_classes[found][group]
        else
          raise ArgumentError, "No validation group of name :#{group}"
        end
      end

      def disable_validation_group
        @current_validation_group = nil
				@current_validation_fields = nil
      end
			
			#can be used
			def should_validate?(attribute)
				@current_validation_fields && @current_validation_fields.include?(attribute.to_sym)
			end

      def validation_group_enabled?
        respond_to?(:current_validation_group) && !current_validation_group.nil?
      end
			
			#alias_method_chain :valid?, :validation_group
			def valid_with_validation_group?(group=nil)
				self.enable_validation_group(group) if group
				valid_without_validation_group?
			end
    end

    module Errors # included in ActiveRecord::Errors
      def add_with_validation_group(attribute,
                                    msg = @@default_error_messages[:invalid], *args,
                                    &block)
        add_error = true
        if @base.validation_group_enabled?
					add_error = false unless @base.current_validation_fields.include?(attribute.to_sym)
				end
				add_without_validation_group(attribute, msg, *args, &block) if add_error
			end
			
      def self.included(base) #:nodoc:
        base.class_eval do
          alias_method_chain :add, :validation_group
        end
      end
    end
  end

  module Util
    # Return array consisting of current and its superclasses
    # down to and including base_class.
    def self.current_and_ancestors(current)
      returning [] do |klasses|
        klasses << current
        root = current.base_class
        until current == root
          current = current.superclass
          klasses << current
        end
      end
    end
  end
end

ActiveRecord::Base.send(:extend, ValidationGroup::ActiveRecord::ActsMethods)
ActiveRecord::Errors.send :include, ValidationGroup::ActiveRecord::Errors
