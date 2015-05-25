require 'redis'

class ChartsController < ApplicationController
  def index
    redis = Redis.new
    memory = JSON.parse(redis.get("memory"))
    @data = memory["reports"].map do |report|
      [report["time"], report["size"]]
    end
  end
end
