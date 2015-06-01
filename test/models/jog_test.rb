require 'test_helper'

class JogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "n is required" do
    assert_raise do
      Jog.create(n: nil)
    end
  end
end
