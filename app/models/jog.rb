class Jog < ActiveRecord::Base
  after_create do
    Resque.enqueue(Run, self.id)
  end
end
