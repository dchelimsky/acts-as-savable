require "acts-as-savable/version"

module ActsAsSavable
  extend ActiveSupport::Concern

  module ClassMethods
    def saves_to(table_name, *attrs)
      class_eval do
        def save(*args)
          _acts_as_savable_object.save(*args)
        end

        def save!(*args)
          _acts_as_savable_object.save!(*args)
        end

        private

        define_method :_acts_as_savable_object do
          klass = Class.new(ActiveRecord::Base) { self.table_name = table_name }
          instance = id ? klass.find(id) : klass.new
          attrs.each {|attr| instance.send("#{attr}=", send(attr))}
          instance
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include ActsAsSavable
end
