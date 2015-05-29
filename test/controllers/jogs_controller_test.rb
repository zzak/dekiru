require 'test_helper'

class JogsControllerTest < ActionController::TestCase
  setup do
    @jog = jogs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create jog" do
    assert_difference('Jog.count') do
      post :create, params: { jog: { n: @jog.n } }
    end

    assert_redirected_to jog_path(Jog.last)
  end

  test "should show jog" do
    get :show, params: { id: @jog }
    assert_response :success
  end

  test "should destroy jog" do
    assert_difference('Jog.count', -1) do
      delete :destroy, params: { id: @jog }
    end

    assert_redirected_to jogs_path
  end
end
