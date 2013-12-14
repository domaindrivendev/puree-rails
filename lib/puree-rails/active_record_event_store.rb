require 'singleton'

module PureeRails

  class ActiveRecordEventStore
    include Singleton

    def create_stream(stream_name, events)
      ActiveRecord::Base.transaction do
        stream = EventStream.new(name: stream_name)
        events.each do |event|
          stream.event_records.new(name: event.name, args: event.args)
        end
        stream.save
      end
    end

    def get_events_for(stream_name)
    end

    def append_events_to(stream_name, events)
    end
  end

  class EventStream < ActiveRecord::Base
    attr_accessible :name
    has_many :event_records
  end

  class EventRecord < ActiveRecord::Base
    attr_accessible :name, :args
    serialize :args
  end
end