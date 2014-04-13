require 'test_helper'

class FoodFeaturesControllerTest < ActionController::TestCase
  setup do
    @food_feature = food_features(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:food_features)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create food_feature" do
    assert_difference('FoodFeature.count') do
      post :create, food_feature: { descr: @food_feature.descr, name: @food_feature.name }
    end

    assert_redirected_to food_feature_path(assigns(:food_feature))
  end

  test "should show food_feature" do
    get :show, id: @food_feature
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @food_feature
    assert_response :success
  end

  test "should update food_feature" do
    patch :update, id: @food_feature, food_feature: { descr: @food_feature.descr, name: @food_feature.name }
    assert_redirected_to food_feature_path(assigns(:food_feature))
  end

  test "should destroy food_feature" do
    assert_difference('FoodFeature.count', -1) do
      delete :destroy, id: @food_feature
    end

    assert_redirected_to food_features_path
  end
end
