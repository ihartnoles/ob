require 'test_helper'

class ModuledatesControllerTest < ActionController::TestCase
  setup do
    @moduledate = moduledates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:moduledates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create moduledate" do
    assert_difference('Moduledate.count') do
      post :create, moduledate: { closedate: @moduledate.closedate, name: @moduledate.name, opendate: @moduledate.opendate }
    end

    assert_redirected_to moduledate_path(assigns(:moduledate))
  end

  test "should show moduledate" do
    get :show, id: @moduledate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @moduledate
    assert_response :success
  end

  test "should update moduledate" do
    put :update, id: @moduledate, moduledate: { closedate: @moduledate.closedate, name: @moduledate.name, opendate: @moduledate.opendate }
    assert_redirected_to moduledate_path(assigns(:moduledate))
  end

  test "should destroy moduledate" do
    assert_difference('Moduledate.count', -1) do
      delete :destroy, id: @moduledate
    end

    assert_redirected_to moduledates_path
  end
end
