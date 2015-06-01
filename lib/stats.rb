class Stats
  def initialize(app, name = nil)
    @app = app
  end

  def call(env)
    status, header, body = @app.call(env)
    env['rack.after_reply'] << lambda { Stats.collect_metrics }
    [status, header, body]
  end

  def self.collect_metrics
    redis = Resque.redis
    if redis.get "results_cache" # only run if results_cache is set
      results_cache = JSON.parse(redis.get("results_cache"))
      time = Time.now.to_i # Current time used for timestamp

      # Cache current process memory size
      results_cache["process_mem"] << {
          :time => time,
          :size => GetProcessMem.new.mb
      }

      # Calculate retained objects and cache
      retained = (
        GC.stat[:total_allocated_objects] - GC.stat[:total_freed_objects]
      )
      results_cache["retained_objects"] << {
        :time => time,
        :size => retained
      }

      redis.set "results_cache", results_cache.to_json
    end
  end
end
