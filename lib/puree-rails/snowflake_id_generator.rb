require 'singleton'

module PureeRails

  class SnowflakeIdGenerator
    include Singleton

    AdjustedEpoch = 1288834974657
    BitsForDatacenterId = 5
    BitsForWorkerId = 5
    BitsForSequence = 12
    TimeStampShift = BitsForDatacenterId + BitsForWorkerId + BitsForSequence
    DatacenterIdShift  = BitsForWorkerId + BitsForSequence
    WorkerIdShift = BitsForSequence
    SequenceRolloverMask = -1 ^ (-1 << BitsForSequence) # AND mask to detect when rollover should occur

    @@lock = Monitor.new

    def initialize
      # TODO: Pull worker_id/datacenter_id from server specific config
      @worker_id = 1
      @datacenter_id = 1
      @sequence = 0
      @last_time_stamp = 0
    end

    def next_id(scope)
      # Id's are guaranteed to be globallly unique - algorithm can ignore scope

      @@lock.synchronize do
        timestamp = current_timestamp

        if (timestamp < @last_time_stamp)
          raise 'Invalid system clocking - appears to moving backwards'
        end

        if (timestamp == @last_time_stamp)
          @sequence = (@sequence + 1) & SequenceRolloverMask
          if (@sequence == 0)
            timestamp = wait_for_next_millisecond
          end
        else
          @sequence = 0
        end

        @last_time_stamp = timestamp

        return ((timestamp - AdjustedEpoch) << TimeStampShift) |
          (@datacenter_id << DatacenterIdShift) |
          (@worker_id << WorkerIdShift) |
          @sequence
      end
    end

    private

    def current_timestamp
      (Time.now.utc.to_f * 1000).to_i
    end

    def wait_for_next_millisecond
      timestamp = current_timestamp
      while (timestamp <= @last_time_stamp)
        timestamp = current_timestamp
      end

      return timestamp
    end
  end
end