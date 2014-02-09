require 'singleton'

module PureeRails

  class ActiveRecordIdGenerator
    include Singleton

    def next_id(scope)
      ActiveRecord::Base.transaction do
        counter = IdCounter.where(scope: scope).first || IdCounter.new(scope: scope)
        counter.increment
        counter.save
        return counter.value
      end
    end
  end

  class IdCounter < ActiveRecord::Base
    attr_accessible :scope, :value
    scope :for, lambda { |scope| where(scope: scope).first }

    after_initialize :set_defaults
    def set_defaults
      self.value ||= 0
    end

    def increment
      self.value += 1
    end
  end
end