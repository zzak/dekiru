class Jog < ActiveRecord::Base
  serialize :results

  after_create do
    Resque.enqueue(Run, self.id)
  end
end
