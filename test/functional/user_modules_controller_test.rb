require 'test_helper'

class UserModulesControllerTest < ActionController::TestCase
  setup do
    @user_module = user_modules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_modules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_module" do
    assert_difference('UserModule.count') do
      post :create, user_module: { module: @user_module.module, module_id: @user_module.module_id, netid: @user_module.netid, userid: @user_module.userid }
    end

    assert_redirected_to user_module_path(assigns(:user_module))
  end

  test "should show user_module" do
    get :show, id: @user_module
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_module
    assert_response :success
  end

  test "should update user_module" do
    put :update, id: @user_module, user_module: { module: @user_module.module, module_id: @user_module.module_id, netid: @user_module.netid, userid: @user_module.userid }
    assert_redirected_to user_module_path(assigns(:user_module))
  end

  test "should destroy user_module" do
    assert_difference('UserModule.count', -1) do
      delete :destroy, id: @user_module
    end

    assert_redirected_to user_modules_path
  end
end
