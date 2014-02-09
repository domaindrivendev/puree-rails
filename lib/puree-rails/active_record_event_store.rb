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
      stream = EventStream.where(name: stream_name).first!
      stream.event_records.map do |record|
        Puree::Event.new(record.name.to_sym, record.args)
      end    
    end

    def append_events_to(stream_name, events)
      stream = EventStream.where(name: stream_name).first!
      stream.transaction do
        events.each do |event|
          stream.event_records.new(name: event.name, args: event.args)
        end
        stream.save
      end  
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