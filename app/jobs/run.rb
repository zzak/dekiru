class Run
  @queue = :runs

  def self.perform(jog_id)
    jog = Jog.find(jog_id)
  end
end
