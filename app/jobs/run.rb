require 'net/http'

class Run
  @queue = :runs

  def self.perform(jog_id)
    # TODO: restart web process before doing work
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

    # Clear cache
    Resque.redis.del "results_cache"

    # Reset cache defaults
    Resque.redis.set "results_cache", {
      :process_mem => [],
      :retained_objects => []
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
