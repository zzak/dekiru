class Stats
  def initialize(app, name = nil)
    @app = app
  end

  def call(env)
    start = Time.now
    status, header, body = @app.call(env)
    stop = Time.now
    env['rack.after_reply'] << lambda do
      Stats.collect_metrics(stop - start)
    end
    [status, header, body]
  end

  def self.collect_metrics(response_time)
    redis = Resque.redis
    if redis.get "results_cache" # only run if results_cache is set
      results_cache = JSON.parse(redis.get("results_cache"))
      time = Time.now.to_i # Current time used for timestamp

      results_cache["response_time"] << {
        :time => time,
        :size => response_time
      }

      # Cache current process memory size
      results_cache["process_mem"] << {
          :time => time,
          :size => GetProcessMem.new.mb
      }

      stats = GC.stat

      # Calculate retained objects and cache
      retained = (
        stats[:total_allocated_objects] - stats[:total_freed_objects]
      )
      results_cache["retained_objects"] << {
        :time => time,
        :size => retained
      }

      # GC runs
      results_cache["major_gc_count"] << {
        :time => time,
        :size => stats[:major_gc_count]
      }
      results_cache["minor_gc_count"] << {
        :time => time,
        :size => stats[:minor_gc_count]
      }

      # Calculate objects in memory
      total_objects = ObjectSpace.count_objects
      results_cache["total_strings"] << {
        :time => time,
        :size => total_objects[:T_STRING]
      }
      results_cache["total_arrays"] << {
        :time => time,
        :size => total_objects[:T_ARRAY]
      }
      results_cache["total_objects"] << {
        :time => time,
        :size => total_objects[:TOTAL]
      }
      results_cache["total_hashes"] << {
        :time => time,
        :size => total_objects[:T_HASH]
      }

      redis.set "results_cache", results_cache.to_json
    end
  end
end
