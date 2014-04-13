require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { brand: @product.brand, category: @product.category, descr: @product.descr, image: @product.image, min_qty_weight: @product.min_qty_weight, on_sale: @product.on_sale, price: @product.price, qty_desc: @product.qty_desc, sale_price: @product.sale_price, sku: @product.sku, sub_category: @product.sub_category, sub_category_group: @product.sub_category_group, uofm: @product.uofm, upc: @product.upc }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: { brand: @product.brand, category: @product.category, descr: @product.descr, image: @product.image, min_qty_weight: @product.min_qty_weight, on_sale: @product.on_sale, price: @product.price, qty_desc: @product.qty_desc, sale_price: @product.sale_price, sku: @product.sku, sub_category: @product.sub_category, sub_category_group: @product.sub_category_group, uofm: @product.uofm, upc: @product.upc }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end
end
