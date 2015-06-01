require 'resque/server'

Resque.redis = ENV["REDIS_URL"]
