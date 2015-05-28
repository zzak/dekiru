require 'redis'
require 'json'

redis = Redis.new
memory = redis.get "memory"
redis.set "memory", {:reports => [], :objects => []}.to_json if memory.nil?
