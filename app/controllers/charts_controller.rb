require 'redis'

class ChartsController < ApplicationController
  def index
    redis = Redis.new
    memory = JSON.parse(redis.get("memory"))
    @usage_data = memory["reports"].map do |report|
      [report["time"]*1000, report["size"]]
    end
    @object_data = memory["objects"].map do |object|
      [object["time"]*1000, object["size"]]
    end
  end
end
