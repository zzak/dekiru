require 'net/http'

class Run
  @queue = :runs

  def self.perform(jog_id)
    # TODO:
    #   - restart web process before doing work
    #   - measure stat in separate process/fork
    jog = Jog.find(jog_id)
    jog.results = {}

    # Warm up
    url = URI.parse(ENV["RUBY_JOGGER_WEB_URL"])
    request = Net::HTTP::Get.new(url.to_s)
    5.times {
      Net::HTTP.start(url.host, url.port) { |http|
        http.request(request)
      }
    }

    # Clear posts db
    Post.destroy_all

    # Clear cache
    Resque.redis.del "results_cache"

    # Reset cache defaults
    Resque.redis.set "results_cache", {
      :process_mem => [],
      :response_time => [],
      :retained_objects => [],
      :total_objects => [],
      :total_strings => [],
      :total_arrays => [],
      :total_hashes => [],
      :minor_gc_count => [],
      :major_gc_count => []
    }.to_json

    # Jog n times
    jog.n.times {
      Net::HTTP.start(url.host, url.port) { |http|
        http.request(request)
      }
    }

    # Set results from cache
    results_cache = JSON.parse(Resque.redis.get("results_cache"))
    jog.results = results_cache
    jog.save
  end
end
