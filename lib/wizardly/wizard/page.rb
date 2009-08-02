require 'wizardly/wizard/text_helpers'

module Wizardly
  module Wizard
    class Page
      include TextHelpers
      
      attr_reader :id, :title, :description
      attr_accessor :buttons, :fields

      def initialize(id, fields)
        @buttons = []
        @title = sym_to_string(id)
        @id = id
        @description = ''
        @fields = fields 
      end

      def name; id.to_s; end

      def buttons_to(*args)
        # #must analyze buttons
        @buttons = args
      end
      def title_to(name)
        @title = name.strip.squeeze(' ')
      end
      def description_to(name)
        @description = name.strip.squeeze(' ')
      end
    end

    class PageField
      attr_reader :name, :column_type

      def initialize(name, type)
        @name = name
        @column_type = type.to_sym
        @field_type = nil
      end

      def field_type
        @field_type ||= case @column_type
        when :string                      then :text_field
        when :password                    then :password_field
        when :text                        then :text_area
        when :boolean                     then :check_box
        when :integer, :float, :decimal   then :text_field
        when :datetime, :timestamp, :time then :datetime_select
        when :date                        then :date_select
        else
          :text_field
        end
      end
    end    
  end
end